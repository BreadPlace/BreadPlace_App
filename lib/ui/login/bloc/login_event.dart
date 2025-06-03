import 'package:equatable/equatable.dart';

sealed class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoggedOut extends LoginEvent {}
class CheckAuthStatus extends LoginEvent {}
class LoginWithKakaoRequested extends LoginEvent {}