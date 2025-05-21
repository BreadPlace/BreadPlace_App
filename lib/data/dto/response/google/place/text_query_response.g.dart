// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_query_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextQueryResponse _$TextQueryResponseFromJson(Map<String, dynamic> json) =>
    TextQueryResponse(
      bakeries:
          (json['places'] as List<dynamic>?)
              ?.map((e) => BakeryDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$TextQueryResponseToJson(TextQueryResponse instance) =>
    <String, dynamic>{'places': instance.bakeries};
