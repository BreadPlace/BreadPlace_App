abstract class LoginException implements Exception {
  final String message;
  LoginException(this.message);
}

class LoginCanceldException extends LoginException {
  LoginCanceldException(): super('로그인이 취소되었습니다.');
}

class LoginFailedException extends LoginException {
  LoginFailedException(): super('로그인이 실패되었습니다.');
}