// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_attribution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorAttribution _$AuthorAttributionFromJson(Map<String, dynamic> json) =>
    AuthorAttribution(
      json['displayName'] as String?,
      json['uri'] as String?,
      json['photoUri'] as String?,
    );

Map<String, dynamic> _$AuthorAttributionToJson(AuthorAttribution instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'uri': instance.uri,
      'photoUri': instance.photoUri,
    };
