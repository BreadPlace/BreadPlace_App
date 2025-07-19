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