import 'dart:core';
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  final String uid;
  final String nickname;
  final String createdAt;

  @JsonKey(defaultValue: '')
  String? updatedAt;

  UserDto({
    required this.uid,
    required this.nickname,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
