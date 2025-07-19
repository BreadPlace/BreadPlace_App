abstract class NicknameEditState {}

class NicknameEditInitial extends NicknameEditState {
  String uid = '';
  bool isNewUser = true;
  String createdAt = '';
  String? updatedAt = '';
}

class NicknameChangeAvailable extends NicknameEditState {
  final String uid;
  final bool isNewUser;
  final String createdAt;
  final String? updatedAt;

  NicknameChangeAvailable({required this.uid, required this.isNewUser, required this.createdAt, this.updatedAt});
}

class NicknameChangeUnavailable extends NicknameEditState {
  final Duration remainingTime;

  NicknameChangeUnavailable(this.remainingTime);
}

class NicknameEditSuccess extends NicknameEditState {}

class NicknameEditFailure extends NicknameEditState {
  final String message;

  NicknameEditFailure(this.message);
}

class NicknameDataFetchFailure extends NicknameEditState {}

class NicknameSavedAndSignedIn extends NicknameEditState {}
