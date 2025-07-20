import 'package:bread_place/domain/entities/user_entity.dart';
import 'package:bread_place/domain/usecases/login_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'nickname_edit_event.dart';
import 'nickname_edit_state.dart';

class NicknameEditBloc extends Bloc<NicknameEditEvent, NicknameEditState> {
  final LoginUseCase _loginUseCase;

  NicknameEditBloc({required LoginUseCase loginUseCase})
    : _loginUseCase = loginUseCase,
      super(NicknameEditInitial()) {
    on<CheckNicknameChangeAvailability>(_onCheckNicknameChangeAvailability);
    on<SubmitNickname>(_onSubmitNickname);
  }

  Future<void> _onCheckNicknameChangeAvailability(
      CheckNicknameChangeAvailability event,
      Emitter<NicknameEditState> emit,
      ) async {
    try {
      final stateResult = await _evaluateNicknameChangeStatus(event.uid);
      emit(stateResult);
    } catch (e) {
      emit(NicknameChangeUnavailable(Duration(hours: 72)));
    }
  }

  Future<NicknameEditState> _evaluateNicknameChangeStatus(String uid) async {
    final userData = await _loginUseCase.getUserDataByUid(uid);

    // 신규 유저 - 아직 DB에 존재하지 않음
    if (userData == null) {
      return NicknameChangeAvailable(
        uid: uid,
        isNewUser: true,
        createdAt: DateTime.now().toIso8601String(),
      );
    }

    // 기존 유저 - 가입할 때 닉네임 저장 이후 updatedAt 없음 → 최초 1회는 제한없이 변경 허용
    if (userData.updatedAt.isEmpty) {
      return NicknameChangeAvailable(
        uid: uid,
        isNewUser: false,
        createdAt: userData.createdAt,
      );
    }

    // 기존 유저 - 72시간 제한 검사
    final updatedTime = DateTime.parse(userData.updatedAt).toLocal();
    final diff = DateTime.now().difference(updatedTime);

    if (diff.inHours >= 72) {
      return NicknameChangeAvailable(
        uid: uid,
        isNewUser: false,
        createdAt: userData.createdAt,
        updatedAt: userData.updatedAt,
      );
    } else {
      return NicknameChangeUnavailable(Duration(hours: 72) - diff);
    }
  }

  // 닉네임 입력이 끝나면, 유저 정보 저장
  Future<void> _onSubmitNickname(SubmitNickname event, Emitter emit) async {
    try {
      final currentState = state;

      if (currentState is NicknameChangeAvailable) {
        String uid = currentState.uid;
        bool isNewUser = currentState.isNewUser;
        String createdAt = currentState.createdAt;
        String newNickname = event.nickname.trim();
        String updatedAt = isNewUser ? '' : DateTime.now().toIso8601String();

        final UserEntity updatedUser = UserEntity(
          uid: uid,
          nickname: newNickname,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

        if (isNewUser) {
          await _loginUseCase.saveNewUser(updatedUser);
          emit(NicknameSavedAndSignedIn());
        } else {
          await _loginUseCase.updateUserNickname(updatedUser);
          emit(NicknameEditSuccess());
        }
      }
    } catch (e) {
      emit(NicknameEditFailure('닉네임 저장 에러 $e'));
    }
  }
}
