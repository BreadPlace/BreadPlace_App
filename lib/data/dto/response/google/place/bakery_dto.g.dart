// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bakery_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BakeryDto _$BakeryDtoFromJson(Map<String, dynamic> json) => BakeryDto(
  displayName: DisplayName.fromJson(
    json['displayName'] as Map<String, dynamic>,
  ),
  languageCode: json['languageCode'] as String,
  formattedAddress: json['formattedAddress'] as String,
  formattedPhoneNumber: json['formattedPhoneNumber'] as String,
  location: json['location'] as String,
  viewPort: json['viewPort'] as String,
  id: json['id'] as String,
  plusCode: json['plusCode'] as String,
  uri: json['googleMapsUri'] as String,
  types:
      (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  photos:
      (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$BakeryDtoToJson(BakeryDto instance) => <String, dynamic>{
  'displayName': instance.displayName.toJson(),
  'languageCode': instance.languageCode,
  'formattedAddress': instance.formattedAddress,
  'formattedPhoneNumber': instance.formattedPhoneNumber,
  'location': instance.location,
  'viewPort': instance.viewPort,
  'id': instance.id,
  'plusCode': instance.plusCode,
  'googleMapsUri': instance.uri,
  'types': instance.types,
  'photos': instance.photos,
};
