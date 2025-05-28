import 'package:json_annotation/json_annotation.dart';

part 'text_search_request.g.dart';

@JsonSerializable()
class TextSearchRequest {
  final String textQuery;

  TextSearchRequest({required this.textQuery});

  factory TextSearchRequest.fromJson(Map<String, dynamic> json) => _$TextSearchRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TextSearchRequestToJson(this);
}