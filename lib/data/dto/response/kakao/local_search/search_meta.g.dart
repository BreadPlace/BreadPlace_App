// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchMeta _$SearchMetaFromJson(Map<String, dynamic> json) => SearchMeta(
  totalCount: (json['total_count'] as num).toInt(),
  pageableCount: (json['pageable_count'] as num).toInt(),
  isEnd: json['is_end'] as bool,
  sameName:
      json['same_name'] == null
          ? null
          : SameName.fromJson(json['same_name'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SearchMetaToJson(SearchMeta instance) =>
    <String, dynamic>{
      'total_count': instance.totalCount,
      'pageable_count': instance.pageableCount,
      'is_end': instance.isEnd,
      'same_name': instance.sameName,
    };
