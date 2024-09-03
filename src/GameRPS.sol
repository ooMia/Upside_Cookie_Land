// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

contract GameRPS {
    enum Hand {
        Rock,
        Paper,
        Scissors
    }

    bytes1 public constant ROCK = bytes1(uint8(Hand.Rock));
    bytes1 public constant PAPER = bytes1(uint8(Hand.Paper));
    bytes1 public constant SCISSORS = bytes1(uint8(Hand.Scissors));

    event GamePlayed(address indexed player, uint256 indexed countPlay, uint256 targetBlock, uint256 timestamp);
    event Claimed(address indexed player, uint256 reward);

    struct RPSPlay {
        address player;
        uint256 timestamp;
        uint256 targetBlock;
        uint256 bet;
        bytes32 hands;
        uint8 streak;
    }

    mapping(address => RPSPlay[]) public games;

    function getUserGameLength(address _user) public view returns (uint256) {
        return games[_user].length;
    }

    function play(address _player, uint256 _amount, bytes1[] memory _hands) public virtual {
        bytes32 hands = handsToBytes32(_hands);
        RPSPlay memory data = toRPS(_amount, hands, uint8(_hands.length));
        games[_player].push(data);
        emit GamePlayed(_player, games[_player].length, data.targetBlock, data.timestamp);
    }

    function play(address _player, uint256 _amount, bytes32 _hands, uint8 _streak) public virtual {
        RPSPlay memory data = toRPS(_amount, _hands, _streak);
        games[_player].push(data);
        emit GamePlayed(_player, games[_player].length, data.targetBlock, data.timestamp);
    }

    /* --- Create Data --- */

    function handsToBytes32(bytes1[] memory _hands) public pure returns (bytes32 result) {
        uint8 len = _hands.length > 32 ? 32 : uint8(_hands.length);
        while (true) {
            result |= bytes32(_hands[--len]);
            if (len == 0) {
                break;
            }
            result >>= 8;
        }
    }

    function toRPS(uint256 _amount, bytes32 _hands, uint8 _streak) public view returns (RPSPlay memory result) {
        result.timestamp = block.timestamp;
        result.targetBlock = block.number + 4;
        result.bet = _amount;
        result.hands = _hands;
        result.player = tx.origin;
        result.streak = _streak;
    }

    /* --- Validation --- */

    function calcMultiplier(uint8 _len, bytes32 _player, bytes32 _dealer) internal pure returns (uint256 multiplier) {
        _len = _len > 32 ? 32 : _len;
        multiplier = 1;

        while (true) {
            multiplier *= rule(_player[_len], _dealer[_len]);
            if (multiplier == 0 || _len == 0) {
                break;
            }
            --_len;
        }
    }

    function rule(bytes1 _player, bytes1 _dealer) internal pure returns (uint8) {
        _player = bytes1(uint8(_player) % 3);
        _dealer = bytes1(uint8(_dealer) % 3);
        if (_player == _dealer) {
            return 1;
        } else if (_player == ROCK && _dealer == SCISSORS) {
            return 2;
        } else if (_player == PAPER && _dealer == ROCK) {
            return 2;
        } else if (_player == SCISSORS && _dealer == PAPER) {
            return 2;
        } else {
            return 0;
        }
    }

    function verify(RPSPlay memory data) internal view returns (uint8 code) {
        if (data.targetBlock >= block.number) {
            return 1; // pass and wait
        }
        if (data.targetBlock + 256 < block.number) {
            return 2; // expired
        }
        return 0; // pass
    }

    function getDealerHash(RPSPlay memory data) public view returns (bytes32) {
        return keccak256(bytes.concat(abi.encode(data), blockhash(data.targetBlock)));
    }

    function claimReward(address owner) public returns (uint256 prize) {
        RPSPlay[] storage myGame = games[owner];
        require(myGame.length > 0, "no game");

        uint256 idx;

        while (idx < myGame.length) {
            RPSPlay memory data = myGame[idx];
            uint8 code = verify(data);
            if (code == 0) {
                prize += data.bet * calcMultiplier(data.streak, data.hands, getDealerHash(data));
            }
            if (code != 1) {
                myGame[idx] = myGame[myGame.length - 1];
                myGame.pop();
            } else {
                idx++;
            }
        }
    }
}
