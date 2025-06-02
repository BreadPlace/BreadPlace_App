// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
  uid: json['uid'] as String,
  nickname: json['nickname'] as String,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String? ?? '',
);

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
  'uid': instance.uid,
  'nickname': instance.nickname,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
