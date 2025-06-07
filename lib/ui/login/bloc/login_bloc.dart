import 'package:bread_place/data/services/local/user_local_storage.dart';
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
    on<LoggedOut>(_onLoggedOut);
    on<CheckAuthStatus>(_onAuthStatusChecked);
    on<LoginWithKakaoRequested>(_loginWithKakao);
    on<LoginCanceled>(_onCanceledLogin);
    on<NicknameSubmitted>(_onNicknameSubmit);
  }

  // 로그아웃 처리
  Future<void> _onLoggedOut(LoggedOut event, Emitter<LoginState> emit) async {
    emit(AuthInProgress());
    try {
      await UserLocalStorage.removeUserId();
      emit(Unauthenticated());
    } catch (e) {
      emit(LogoutFailure());
    }
  }

  // 로그인 상태 확인 처리
  Future<void> _onAuthStatusChecked(
    CheckAuthStatus event,
    Emitter<LoginState> emit,
  ) async {
    emit(AuthInProgress());
    String? cachedId = await UserLocalStorage.getUserId();

    (cachedId != null)
        ? emit(Authenticated(uid: cachedId, createdAt: ''))
        : emit(Unauthenticated());
  }

  /// 카카오 로그인 로직
  Future<void> _loginWithKakao(
    LoginWithKakaoRequested event,
    Emitter<LoginState> emit,
  ) async {
    try {
      bool isKakaoTalkAvailable = await isKakaoTalkInstalled();

      // 로그인 시도
      isKakaoTalkAvailable
          ? await _tryLoginWithKakaoTalk()
          : await _tryLoginWithKakaoAccount();

      // 로그인 성공 이후
      final userInfo = await UserApi.instance.me();
      final uid = userInfo.id.toString();

      // 로컬 저장
      await UserLocalStorage.saveUserId(uid);

      // 데이터가 없으면 신규유저
      final userData = await _fetchUserDataByUid(uid);

      // 신규 유저 -> 닉네임 입력받는 화면으로 이동
      if (userData == null) {
        emit(
          NicknameInputInProgress(
            uid: uid,
            createdAt: DateTime.now().toIso8601String(),
          ),
        );
      } else {
        emit(
          Authenticated(
            uid: userData.uid,
            createdAt: userData.createdAt,
            nickname: userData.nickname,
          ),
        );
      }
    } on PlatformException catch (e) {
      // 사용자가 로그인 취소한 경우
      if (e.code == 'CANCELED') {
        print('사용자 로그인 취소');
      } else {
        print('카카오 로그인 오류: $e');
      }
      emit(LoginFailure());
    } catch (e) {
      print('알 수 없는 로그인 오류: $e');
      emit(LoginFailure());
    }
  }

  // 카카오톡 앱으로 로그인 시도
  Future<void> _tryLoginWithKakaoTalk() async {
    final token = await UserApi.instance.loginWithKakaoTalk();
    token.idToken;
  }

  // 카카오계정으로 로그인 시도
  Future<void> _tryLoginWithKakaoAccount() async {
    await UserApi.instance.loginWithKakaoAccount();
  }

  Future<UserEntity?> _fetchUserDataByUid(String uid) async {
    try {
      final userData = await _repository.fetchUserDataByUid(uid);
      return userData;
    } catch (e) {
      print("_fetchUserData 에러 $e");
      return null;
    }
  }

  Future<void> _saveUserToServer(UserEntity user) async {
    try {
      await _repository.saveUser(user); // 파이어베이스 저장
    } catch (e) {
      print("_saveUserId 에러 $e");
    }
  }

  // 닉네임 입력이 끝나면, 유저 정보 저장
  Future<void> _onNicknameSubmit(NicknameSubmitted event, Emitter emit) async {
    final nickname = event.nickname.trim();

    // 나중에 입력하기 선택 시, 닉네임 랜덤 생성
    final resolveNickname =
        (nickname.isNotEmpty) ? nickname : generateTimestampNickname();

    if (state is NicknameInputInProgress) {
      final current = state as NicknameInputInProgress;

      final UserEntity user = UserEntity(
        uid: current.uid,
        createdAt: current.createdAt,
        nickname: resolveNickname,
      );

      await _saveUserToServer(user); // 서버 저장

      // 상태 전환
      emit(
        Authenticated(
          uid: user.uid,
          createdAt: user.createdAt,
          nickname: user.nickname,
        ),
      );
    }
  }

  // 로그인 취소
  void _onCanceledLogin(LoginCanceled event, Emitter emit) {
    emit(LoginFailure());
  }
}
