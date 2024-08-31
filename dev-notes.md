본격 개발 들어가기 전에 컨트랙트 역할이랑 함수 명명하고, 설명 자세하게 해두기
대신 너무 깊게 들어가지 말고, 최대한 간소화해서 v1 만들기
패턴 신경쓰지 말고 일단 개발하고, 나중에 리팩토링 하기

v1의 목표는 인터페이스를 구축하고
각 인터페이스에 대한 상세 구현 설명을 작성하는 것

일단 컴포넌트는 모두 구성함

1. Proxy
2. Logic: Station
3. ERC20: Cookie
4. Logic: Oracle (Random)
5. Logic: Game



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
