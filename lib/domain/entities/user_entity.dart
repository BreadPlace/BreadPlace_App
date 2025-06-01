class UserEntity {
  final String uid;
  String nickname;
  final String createdAt;
  String updatedAt;

  UserEntity({
    required this.uid,
    this.nickname = '',
    required this.createdAt,
    this.updatedAt = '',
  });
}