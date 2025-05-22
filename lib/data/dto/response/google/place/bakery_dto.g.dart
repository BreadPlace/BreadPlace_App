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
  formattedPhoneNumber: json['nationalPhoneNumber'] as String,
  location: LocationDto.fromJson(json['location'] as Map<String, dynamic>),
  viewPort: ViewportDto.fromJson(json['viewPort'] as Map<String, dynamic>),
  id: json['id'] as String,
  plusCode: PlusCodeDto.fromJson(json['plusCode'] as Map<String, dynamic>),
  uri: json['googleMapsUri'] as String,
  types:
      (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  photos: PhotoDto.fromJson(json['photos'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BakeryDtoToJson(BakeryDto instance) => <String, dynamic>{
  'id': instance.id,
  'languageCode': instance.languageCode,
  'formattedAddress': instance.formattedAddress,
  'nationalPhoneNumber': instance.formattedPhoneNumber,
  'googleMapsUri': instance.uri,
  'types': instance.types,
  'displayName': instance.displayName.toJson(),
  'location': instance.location.toJson(),
  'viewPort': instance.viewPort.toJson(),
  'plusCode': instance.plusCode.toJson(),
  'photos': instance.photos.toJson(),
};
