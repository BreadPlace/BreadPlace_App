import 'package:equatable/equatable.dart';

sealed class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoggedOut extends LoginEvent {}
class CheckAuthStatus extends LoginEvent {}
class LoginWithKakaoRequested extends LoginEvent {}
class LoginWithGoogleRequested extends LoginEvent {}

class LoginCanceled extends LoginEvent {}

// 닉네임 입력 시작
class NicknameInputStarted extends LoginEvent {}

// 닉네임 입력 취소
class NicknameInputCanceled extends LoginEvent {}

// 닉네임 입력 후 저장 요청
class NicknameSubmitted extends LoginEvent {
  final String nickname;

  NicknameSubmitted(this.nickname);

  @override
  List<Object?> get props => [nickname];
}