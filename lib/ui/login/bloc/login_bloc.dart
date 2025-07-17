import 'package:bread_place/config/constants/app_social_platform.dart';
import 'package:bread_place/config/constants/exception/login_exception.dart';
import 'package:bread_place/domain/entities/user_entity.dart';
import 'package:bread_place/domain/repositories/firestore_repository.dart';
import 'package:bread_place/domain/repositories/user_local_storage_repository.dart';
import 'package:bread_place/domain/usecases/login_use_case.dart';
import 'package:bread_place/domain/usecases/user_local_storage_use_case.dart';
import 'package:bread_place/ui/login/bloc/login_event.dart';
import 'package:bread_place/ui/login/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirestoreRepository _firestoreRepo;
  final UserLocalStorageRepository _userLocalStorageRepo;
  final LoginUseCase _loginUseCase;
  final UserLocalStorageUseCase _userLocalStorageUseCase;

  LoginBloc(
      this._firestoreRepo,
      this._userLocalStorageRepo,
      this._loginUseCase,
      this._userLocalStorageUseCase
  ): super(Unauthenticated()) {
    on<LoggedOut>(_onLoggedOut);
    on<CheckAuthStatus>(_onAuthStatusChecked);
    on<LoginCanceled>(_onCanceledLogin);
    on<NicknameSubmitted>(_onNicknameSubmit);
    on<OpenNicknameEditScreen>(_onOpenNicknameEditScreen);
    on<LoginRequested>((event, emit) async {
      await _login(event, emit);
    });
  }

  // 로그아웃 처리
  Future<void> _onLoggedOut(LoggedOut event, Emitter<LoginState> emit) async {
    emit(AuthInProgress());
    try {
      await _userLocalStorageUseCase.removeUserId();
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
    String? cachedId = await _userLocalStorageUseCase.getUserId();
    String? cachedNickname = await _userLocalStorageUseCase.getUserNickname();

    (cachedId != null)
        ? emit(Authenticated(uid: cachedId, nickname: cachedNickname, createdAt: '',))
        : emit(Unauthenticated());
  }


  /// 로그인 로직
  Future<void> _login (
      LoginRequested event,
      Emitter<LoginState> emit,
      ) async {
    try {
      final String uid;

      switch(event.platform) {
        case AppSocialPlatform.kakao:
          uid = await _loginUseCase.loginWithKakaoAndGetUID();
          break;
        case AppSocialPlatform.google:
          uid = await _loginUseCase.loginWithGoogleAndGetUID();
          break;
      }

      // UID로 유저 데이터 가져오기(없으면 새로운 유저)
      final userData = await _loginUseCase.getUserDataByUid(uid);

      // 신규 유저 -> 닉네임 입력받는 화면으로 이동
      if (userData == null) {
        emit(NicknameEditing(
            uid: uid,
            createdAt: DateTime.now().toIso8601String(),
            isNewUser: true)
        );
      } else {
        // 기존 유저 -> 아이디, 닉네임 저장
        await _userLocalStorageRepo.saveUserId(userData.uid);
        await _userLocalStorageRepo.saveUserNickname(userData.nickname);

        emit(
          Authenticated(
            uid: userData.uid,
            createdAt: userData.createdAt,
            nickname: userData.nickname,
          ),
        );
      }
    } on LoginCanceldException {
      emit(LoginFailure());
    } on LoginFailedException {
      emit(LoginFailure());
    }
  }

  // 닉네임 입력이 끝나면, 유저 정보 저장
  Future<void> _onNicknameSubmit(NicknameSubmitted event, Emitter emit) async {
    try {
      final currentState = state;

      if (currentState is NicknameEditing) {
        String uid = currentState.uid;
        String createdAt = currentState.createdAt;
        bool isNewUser = currentState.isNewUser;
        String nickname = event.nickname.trim();

        final UserEntity updatedNickname = UserEntity(
            uid: uid,
            createdAt: createdAt,
            nickname: nickname
        );

        if(isNewUser) {
          await _loginUseCase.saveNewUser(updatedNickname);
        } else {
          await _loginUseCase.updateUserNickname(uid, nickname);
        }

        emit(NicknameEdited());

        await _userLocalStorageUseCase.saveUidAndNickname(uid, nickname);
        emit(Authenticated(uid: uid, createdAt: createdAt, nickname: nickname));
      }

    } catch(e) {
      emit(NicknameEditFailure());
    }

  }

  //
  void _onOpenNicknameEditScreen(OpenNicknameEditScreen event, Emitter emit) {
    emit(NicknameEditing(uid: event.uid, createdAt: event.createdAt, isNewUser: false));
  }

  // 로그인 취소
  void _onCanceledLogin(LoginCanceled event, Emitter emit) {
    emit(LoginFailure());
  }
}
