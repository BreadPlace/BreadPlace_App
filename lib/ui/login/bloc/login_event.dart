import 'package:bread_place/config/constants/app_social_platform.dart';
import 'package:equatable/equatable.dart';

sealed class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoggedOut extends LoginEvent {}
class CheckAuthStatus extends LoginEvent {}

// 로그인 요청
class LoginRequested extends LoginEvent {
  final AppSocialPlatform platform;

  LoginRequested({
    required this.platform
  });
}

class LoginCanceled extends LoginEvent {}

// 닉네임 입력 후 저장 요청
class NicknameSubmitted extends LoginEvent {
  final String nickname;

  NicknameSubmitted(this.nickname);

  @override
  List<Object?> get props => [nickname];
}

class OpenNicknameEditScreen extends LoginEvent {
  final String uid;
  final String createdAt;
  final String? oldNickname;

  OpenNicknameEditScreen({required this.uid, required this.createdAt, this.oldNickname});
}