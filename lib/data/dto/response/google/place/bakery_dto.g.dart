// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bakery_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BakeryDto _$BakeryDtoFromJson(Map<String, dynamic> json) => BakeryDto(
  displayName: DisplayName.fromJson(
    json['displayName'] as Map<String, dynamic>,
  ),
  formattedAddress: json['formattedAddress'] as String,
);

Map<String, dynamic> _$BakeryDtoToJson(BakeryDto instance) => <String, dynamic>{
  'displayName': instance.displayName,
  'formattedAddress': instance.formattedAddress,
};
