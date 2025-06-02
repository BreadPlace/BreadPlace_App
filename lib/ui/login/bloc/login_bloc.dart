import 'package:bread_place/domain/entities/user_entity.dart';
import 'package:bread_place/domain/repositories/firestore_repository.dart';
import 'package:bread_place/utils/generate_timestamp_nickname.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirestoreRepository _repository;

  LoginBloc(this._repository) : super(Unauthenticated()) {
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
    on<CheckAuthStatus>(_onAuthStatusChecked);
    on<LoginWithKakaoRequested>(_loginWithKakao);
  }

  // 로그인 처리
  Future<void> _onLoggedIn(LoggedIn event, Emitter<LoginState> emit) async {
    emit(AuthInProgress());
    try {
      // await _loginWithKakao():
      emit(Authenticated());
    } catch (e) {
      emit(LoginFailure());
    }
  }

  // 로그아웃 처리
  Future<void> _onLoggedOut(LoggedOut event, Emitter<LoginState> emit) async {
    emit(AuthInProgress());
    try {
      // await _logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(LogoutFailure());
    }
  }

  // 인증 상태 확인 처리
  Future<void> _onAuthStatusChecked(CheckAuthStatus event, Emitter<LoginState> emit) async {
    emit(AuthInProgress());
    bool hasKakaoToken = await AuthApi.instance.hasToken();

    hasKakaoToken
    ? emit(Authenticated())
    : emit(Unauthenticated());
  }

  /// 카카오 로그인 로직
  Future<void> _loginWithKakao(LoginWithKakaoRequested event, Emitter<LoginState> emit) async {
    try {
      bool isKakaoTalkAvailable = await isKakaoTalkInstalled();

      isKakaoTalkAvailable
          ? await _tryLoginWithKakaoTalk(emit)
          : await _tryLoginWithKakaoAccount(emit);
    } catch(e) {
      print('카카오 로그인 실패 $e');
    }
  }

  // 카카오톡 앱으로 로그인 시도
  Future<void> _tryLoginWithKakaoTalk(Emitter<LoginState> emit) async {
    try {
      final token = await UserApi.instance.loginWithKakaoTalk();

      if (token.accessToken.isNotEmpty) {
        final userInfo = await _getUserInfoWithKakao();
        await _saveUser(userInfo); // 파이어베이스 저장
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    } catch (error) {
      // 사용자가 로그인 화면에서 취소한 경우
      if (error is PlatformException && error.code == 'CANCELED') {
        emit(Unauthenticated());
        return; // 이후 계정 로그인 시도하지 않음
      }
    }
  }

  // 카카오계정으로 로그인 시도
  Future<void> _tryLoginWithKakaoAccount(Emitter<LoginState> emit) async {
    try {
      final token = await UserApi.instance.loginWithKakaoAccount();

      if (token.accessToken.isNotEmpty) {
        final userInfo = await _getUserInfoWithKakao();
        await _saveUser(userInfo); // 파이어베이스 저장
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }

    } catch (error) {
      emit(Unauthenticated());
      print('카카오계정으로 로그인 실패 $error');
    }
  }

  // 유저 정보를 파이어베이스에 저장
  Future<void> _saveUser(UserEntity user) async {
    try {
      bool success = await _repository.saveUser(user); // 저장 시도
      // 성공 여부에 따라 토스트 메세지
    } catch (e) {
      print("saveUserWithKakaoId 에러 $e");
    }
  }

  // 카카오 토큰으로 유저 정보를 가져옴
  Future<UserEntity> _getUserInfoWithKakao() async {
    final userInfo = await UserApi.instance.me();
    UserEntity user = UserEntity(
        uid: userInfo.id.toString(),
        nickname: generateTimestampNickname(), // 랜덤 닉네임 생성
        createdAt: userInfo.connectedAt?.toIso8601String() ?? DateTime.now().toIso8601String()
    );
    return user;
  }
}