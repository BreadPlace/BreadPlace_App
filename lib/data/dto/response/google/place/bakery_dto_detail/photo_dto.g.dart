// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoDto _$PhotoDtoFromJson(Map<String, dynamic> json) => PhotoDto(
  json['name'] as String?,
  (json['widthPx'] as num?)?.toInt(),
  (json['heightPx'] as num?)?.toInt(),
  (json['authorAttributions'] as List<dynamic>?)
          ?.map((e) => AuthorAttribution.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$PhotoDtoToJson(PhotoDto instance) => <String, dynamic>{
  'name': instance.name,
  'widthPx': instance.widthPx,
  'heightPx': instance.heightPx,
  'authorAttributions': instance.authorAttributions,
};
