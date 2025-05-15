// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'same_name.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SameName _$SameNameFromJson(Map<String, dynamic> json) => SameName(
  region: (json['region'] as List<dynamic>).map((e) => e as String).toList(),
  keyword: json['keyword'] as String,
  selectedRegion: json['selected_region'] as String,
);

Map<String, dynamic> _$SameNameToJson(SameName instance) => <String, dynamic>{
  'region': instance.region,
  'keyword': instance.keyword,
  'selected_region': instance.selectedRegion,
};
