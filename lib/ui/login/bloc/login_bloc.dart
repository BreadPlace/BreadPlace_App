import 'package:bread_place/config/constants/exception/login_exception.dart';
import 'package:bread_place/domain/entities/user_entity.dart';
import 'package:bread_place/domain/usecases/login_use_case.dart';
import 'package:bread_place/domain/usecases/user_local_storage_use_case.dart';
import 'package:bread_place/ui/login/bloc/login_event.dart';
import 'package:bread_place/ui/login/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;
  final UserLocalStorageUseCase _userLocalStorageUseCase;

  LoginBloc(this._loginUseCase, this._userLocalStorageUseCase)
    : super(Unauthenticated()) {
    on<LoggedOut>(_onLoggedOut);
    on<WithDraw>(_onWithDraw);
    on<CheckAuthStatus>(_onAuthStatusChecked);
    on<LoginCanceled>(_onCanceledLogin);
    on<LoginRequested>((event, emit) async {
      await _login(event, emit);
    });
  }

  // 로그아웃 처리
  Future<void> _onLoggedOut(LoggedOut event, Emitter<LoginState> emit) async {
    emit(AuthInProgress());
    try {
      await _loginUseCase.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(LogoutFailure());
    }
  }

  Future<void> _onWithDraw(WithDraw event, Emitter<LoginState> emit) async {
    emit(AuthInProgress());
    try {
      await _loginUseCase.withDraw();
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

    final user = _userLocalStorageUseCase.getUserData();

    (user.uid.isNotEmpty)
        ? emit(
          Authenticated(
            uid: user.uid,
            nickname: user.nickname,
            createdAt: user.createdAt,
          ),
        )
        : emit(Unauthenticated());
  }

  /// 로그인 로직
  Future<void> _login(LoginRequested event, Emitter<LoginState> emit) async {
    try {
      // 로그인 성공 시 UID 가져오기
      final uid = await _loginUseCase.loginAndGetUID(event.platform);

      // UID로 유저 데이터 가져오기(없으면 새로운 유저)
      final userData = await _loginUseCase.getUserDataByUid(uid);

      // 신규 유저 -> 닉네임 입력받는 화면으로 이동
      if (userData == null) {
        emit(NewUserRequireNickname(uid: uid));
      } else {
        // 기존 유저 -> 아이디, 닉네임, 생성일 저장
        String nickname = userData.nickname;
        String createdAt = userData.createdAt;

        final user = UserEntity(
          uid: uid,
          createdAt: createdAt,
          nickname: nickname,
        );
        await _userLocalStorageUseCase.saveUserData(user);

        emit(Authenticated(uid: uid, createdAt: createdAt, nickname: nickname));
      }
    } on LoginCanceldException {
      emit(LoginFailure());
    } on LoginFailedException {
      emit(LoginFailure());
    }
  }

  // 로그인 취소
  void _onCanceledLogin(LoginCanceled event, Emitter emit) {
    emit(LoginFailure());
  }
}
