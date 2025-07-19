

abstract class NicknameEditEvent {}

class CheckNicknameChangeAvailability extends NicknameEditEvent {
  final String uid;
  final bool isNewUser;

  CheckNicknameChangeAvailability({required this.uid, required this.isNewUser});
}

class SubmitNickname extends NicknameEditEvent {
  final String nickname;

  SubmitNickname({required this.nickname,});
}