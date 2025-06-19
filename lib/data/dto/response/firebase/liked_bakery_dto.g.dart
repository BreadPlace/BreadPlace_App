// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liked_bakery_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikedBakeryDto _$LikedBakeryDtoFromJson(Map<String, dynamic> json) =>
    LikedBakeryDto(
      bakeryId: json['bakeryId'] as String,
      isNotify: json['isNotify'] as bool,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$LikedBakeryDtoToJson(LikedBakeryDto instance) =>
    <String, dynamic>{
      'bakeryId': instance.bakeryId,
      'isNotify': instance.isNotify,
      'updatedAt': instance.updatedAt,
    };
