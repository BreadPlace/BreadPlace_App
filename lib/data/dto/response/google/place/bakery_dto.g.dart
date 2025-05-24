// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bakery_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BakeryDto _$BakeryDtoFromJson(Map<String, dynamic> json) => BakeryDto(
  id: json['id'] as String,
  types:
      (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  formattedAddress: json['formattedAddress'] as String?,
  uri: json['googleMapsUri'] as String?,
  formattedPhoneNumber: json['nationalPhoneNumber'] as String?,
  displayName:
      json['displayName'] == null
          ? null
          : DisplayName.fromJson(json['displayName'] as Map<String, dynamic>),
  location:
      json['location'] == null
          ? null
          : LocationDto.fromJson(json['location'] as Map<String, dynamic>),
  viewPort:
      json['viewPort'] == null
          ? null
          : ViewportDto.fromJson(json['viewPort'] as Map<String, dynamic>),
  plusCode:
      json['plusCode'] == null
          ? null
          : PlusCodeDto.fromJson(json['plusCode'] as Map<String, dynamic>),
  photos:
      (json['photos'] as List<dynamic>?)
          ?.map((e) => PhotoDto.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$BakeryDtoToJson(BakeryDto instance) => <String, dynamic>{
  'id': instance.id,
  'formattedAddress': instance.formattedAddress,
  'googleMapsUri': instance.uri,
  'nationalPhoneNumber': instance.formattedPhoneNumber,
  'types': instance.types,
  'displayName': instance.displayName?.toJson(),
  'location': instance.location?.toJson(),
  'viewPort': instance.viewPort?.toJson(),
  'plusCode': instance.plusCode?.toJson(),
  'photos': instance.photos?.map((e) => e.toJson()).toList(),
};
