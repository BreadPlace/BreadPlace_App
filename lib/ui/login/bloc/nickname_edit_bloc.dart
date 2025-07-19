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

    if(event.isNewUser) {
      emit(
        NicknameChangeAvailable(
          uid: event.uid,
          isNewUser: true,
          createdAt: DateTime.now().toIso8601String(),
        ),
      );
      return;
    }

    final fetchedUserData = await _loginUseCase.getUserDataByUid(event.uid);

    if (fetchedUserData == null) {
      emit(NicknameDataFetchFailure());
      return;
    }

    // 신규 유저 최초 1회 등록 시
    if (fetchedUserData.updatedAt.isEmpty) {
      emit(
        NicknameChangeAvailable(
          uid: event.uid,
          isNewUser: true,
          createdAt: fetchedUserData.createdAt,
        ),
      );
      return;
    }

    try {
      final updatedTime = DateTime.parse(fetchedUserData.updatedAt).toLocal();
      final now = DateTime.now();
      final diff = now.difference(updatedTime);

      // 변경 후 72 시간 지남
      if (diff.inHours >= 72) {
        emit(
          NicknameChangeAvailable(
            uid: event.uid,
            isNewUser: false,
            createdAt: fetchedUserData.createdAt,
            updatedAt: fetchedUserData.updatedAt,
          ),
        );
      } else {
        // 변경 후 72 시간 안지남
        emit(NicknameChangeUnavailable(Duration(hours: 72) - diff));
      }
    } catch (_) {
      emit(NicknameChangeUnavailable(Duration(hours: 72)));
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
