sealed class LoginState {}

// 인증 여부 확인 중
class AuthInProgress extends LoginState {}

// 로그인 성공
class Authenticated extends LoginState {}

// 로그인되지 않은 상태
class Unauthenticated extends LoginState {}

// 로그인 처리 중
class LoginInProgress extends LoginState {}

// 로그인 실패
class LoginFailure extends LoginState {}

// 로그아웃 실패
class LogoutFailure extends LoginState {}