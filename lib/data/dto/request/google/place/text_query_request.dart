import 'package:json_annotation/json_annotation.dart';

part 'text_query_request.g.dart';

@JsonSerializable()
class TextQueryRequest {
  final String textQuery;

  TextQueryRequest({required this.textQuery});

  factory TextQueryRequest.fromJson(Map<String, dynamic> json) => _$TextQueryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TextQueryRequestToJson(this);
}