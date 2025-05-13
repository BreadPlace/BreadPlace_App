// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) =>
    SearchResponse(
      meta: SearchMeta.fromJson(json['meta'] as Map<String, dynamic>),
      documents:
          (json['documents'] as List<dynamic>)
              .map((e) => SearchDocument.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$SearchResponseToJson(SearchResponse instance) =>
    <String, dynamic>{'meta': instance.meta, 'documents': instance.documents};
