import 'package:bread_place/data/dto/response/firebase/user_dto.dart';
import 'package:bread_place/domain/entities/user_entity.dart';

// UserDto → UserEntity
extension UserMapper on UserDto {
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      nickname: nickname,
      createdAt: createdAt,
      updatedAt: updatedAt ?? '',
    );
  }
}

// UserEntity -> UserDto
extension UserDtoMapper on UserEntity {
  UserDto toDto() {
    return UserDto(
      uid: uid,
      nickname: nickname,
      createdAt: createdAt,
      updatedAt: updatedAt ?? '',
    );
  }
}
