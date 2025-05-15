import 'package:json_annotation/json_annotation.dart';

import 'package:bread_place/data/dto/response/kakao/local_search/search_document.dart';
import 'package:bread_place/data/dto/response/kakao/local_search/search_meta.dart';

part 'search_response.g.dart';

@JsonSerializable()
class SearchResponse {
  final SearchMeta meta;
  final List<SearchDocument> documents;

  SearchResponse({required this.meta, required this.documents});

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);
}
