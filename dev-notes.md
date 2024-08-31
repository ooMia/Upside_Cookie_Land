# v1: components setup

![structure](https://github.com/user-attachments/assets/2ff5a299-9350-4cf4-b59c-4d0f868a034a)

1. Proxy
2. Logic: Station
3. ERC20: Cookie
4. Logic: Oracle (Random)
5. Logic: Game

본격 개발 들어가기 전에 컨트랙트 역할이랑 함수 명명하고, 설명 자세하게 해두기
대신 너무 깊게 들어가지 말고, 최대한 간소화해서 v1 만들기
패턴 신경쓰지 말고 일단 개발하고, 나중에 리팩토링 하기

v1의 목표는 인터페이스를 구축하고
각 인터페이스에 대한 상세 구현 설명을 작성하는 것

일단 컴포넌트는 모두 구성함

![work-flow](https://shorturl.at/9tQy0)

1. Game

정산하는 로직 되게 중요함
일단 사용자가 게임을 신청? 하면 그 스토리지에 저장됨
우리가 즉각적으로 랜덤 값을 가져다가 쓰는 것이 아니기 떄문에
나중에 랜덤 값이 초기화되었을 때, 그제서야 정산이 가능함

그래서 정산에 대한 호출이 불렸을 때,
일단 플레이어들의 플레이 기록이 있는지 확인할 수 있으면 좋고
아무튼 그렇게 랜덤 오라클 업데이트를 진행하면
오라클 쪽에서는 업데이트해서 랜덤 해시를 설정한 다음에
우리 설정했어 가져다가 써ㅡ 전달하면 되고

근데 스테이션에서 또는 게임에서 주의해야 할 점은
유저가 입력한 블록 넘버가 현재 주어진 블록 해쉬의 블록 넘버보다 작으면 안 된다
는 것이다. 이거 진짜 중요한데, 예를 들어서, block.number == 1 일 때, 게임을 신청했고, 그거에 대한 데이터가 들어가있어
근데 현재 랜덤 값이 2번 블록에서 나왔다고 하면, 1번 블록에서 게임을 신청한 사람은 그 값을 가져다 쓸 수 없음 (조건은 설정하기 나름인데, 가능하면 4개 블록 뒤에 나온 랜덤 값을 가져다 쓰는 것이 좋을 듯)
그래서 게임을 신청할 때, 블록 넘버를 입력받아서, 그 블록 넘버가 현재 블록 넘버보다 작으면 안 된다는 것을 체크해야 함

각각의 게임에서 사용하는 struct를 정의해서 호출하는 사람이 편하도록 해야 함

랜덤 받아오는 것도 중요함. 이것도 따로 빼두고
간단한 오라클 정도는 만들어볼까 -> 이거 할 시간에 다른 거 구체화

// TODO 코드 패턴: State Machine
// TODO 코드 패턴: Proxy Pattern
// TODO 코드 패턴: Multicall Pattern
// TODO 코드 패턴: Checks Effects Interactions
// TODO 코드 패턴: [Pull over Push](https://fravoll.github.io/solidity-patterns/pull_over_push.html)
// TODO 코드 패턴: Emergency Stop

// TODO 도전 과제 #1: 추가 패턴 [secure_ether_transfer](https://fravoll.github.io/solidity-patterns/secure_ether_transfer.html)

// TODO 도전 과제 #1: 추가 패턴 [solidity-patterns]https://fravoll.github.io/solidity-patterns/)

// TODO 도전 과제 #2. 토크노믹스

// TODO 도전 과제 #3: 취약점

// TODO 도전과제 #4: 성능/가스 최적화

// TODO Ownable 패턴
// TODO Pausable 패턴
// TODO Pull Payment 패턴
// TODO Circuit Breaker 패턴
// TODO State Machine 패턴
// TODO Oracle 패턴
// TODO Proxy 패턴
// TODO Library 패턴
// TODO Factory 패턴
