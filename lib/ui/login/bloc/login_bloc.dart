import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(Unauthenticated()) {
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
    try {
      // final user = await _getCurrentUser();
      // if (user != null) {
        emit(Authenticated());
      // } else {
      //   emit(Unauthenticated());
      // }
    } catch (e) {
      emit(AuthFailure());
    }
  }

  // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
  Future<void> _loginWithKakao(LoginWithKakaoRequested event, Emitter<LoginState> emit) async {
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }
}
