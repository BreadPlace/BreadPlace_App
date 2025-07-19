import 'package:equatable/equatable.dart';

sealed class LoginState extends Equatable {
  @override
  List<Object?> get props =>  [];
}

// 인증 여부 확인 중
class AuthInProgress extends LoginState {}

// 로그인 성공
class Authenticated extends LoginState {
  final String uid;
  final String createdAt;
  final String? nickname; // nullable

  Authenticated({
    required this.uid,
    required this.createdAt,
    this.nickname,
  });

  Authenticated copyWith({
    String? uid,
    String? createdAt,
    String? nickname,
  }) {
    return Authenticated(
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      nickname: nickname ?? this.nickname,
    );
  }

  @override
  List<Object?> get props => [uid, createdAt, nickname];
}

// 로그인되지 않은 상태
class Unauthenticated extends LoginState {}

// 로그인 처리 중
class LoginInProgress extends LoginState {}

// 로그인 실패
class LoginFailure extends LoginState {}

// 로그아웃 실패
class LogoutFailure extends LoginState {}

// 신규 유저라면 닉네임 등록 화면으로 이동
class NewUserRequireNickname extends LoginState {
  final String uid;

  NewUserRequireNickname({required this.uid});
}