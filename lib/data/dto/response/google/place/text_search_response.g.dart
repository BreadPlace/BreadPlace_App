// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextSearchResponse _$TextSearchResponseFromJson(Map<String, dynamic> json) =>
    TextSearchResponse(
      bakeries:
          (json['places'] as List<dynamic>?)
              ?.map((e) => BakeryDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$TextSearchResponseToJson(TextSearchResponse instance) =>
    <String, dynamic>{'places': instance.bakeries};
