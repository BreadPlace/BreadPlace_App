// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_port.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ViewportDto _$ViewportDtoFromJson(Map<String, dynamic> json) => ViewportDto(
  low:
      json['low'] == null
          ? null
          : LocationDto.fromJson(json['low'] as Map<String, dynamic>),
  high:
      json['high'] == null
          ? null
          : LocationDto.fromJson(json['high'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ViewportDtoToJson(ViewportDto instance) =>
    <String, dynamic>{'low': instance.low, 'high': instance.high};
