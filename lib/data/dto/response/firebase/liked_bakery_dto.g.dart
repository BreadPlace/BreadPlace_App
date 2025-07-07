// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liked_bakery_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikedBakeryDto _$LikedBakeryDtoFromJson(Map<String, dynamic> json) =>
    LikedBakeryDto(
      bakeryId: json['bakeryId'] as String,
      isNotificationAllowed: json['isNotificationAllowed'] as bool,
      updatedAt: json['updatedAt'] as String,
      displayName: json['displayName'] as String,
      address: json['address'] as String?,
      locationLat: json['locationLat'] as String?,
      locationLong: json['locationLong'] as String?,
    );

Map<String, dynamic> _$LikedBakeryDtoToJson(LikedBakeryDto instance) =>
    <String, dynamic>{
      'bakeryId': instance.bakeryId,
      'isNotificationAllowed': instance.isNotificationAllowed,
      'updatedAt': instance.updatedAt,
      'displayName': instance.displayName,
      'address': instance.address,
      'locationLat': instance.locationLat,
      'locationLong': instance.locationLong,
    };
