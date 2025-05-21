import 'package:bread_place/data/dto/response/google/place/bakery_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'text_query_response.g.dart';

@JsonSerializable()
class TextQueryResponse {
  @JsonKey(name: 'places', defaultValue: [])
  final List<BakeryDto> bakeries;

  TextQueryResponse({required this.bakeries});

  factory TextQueryResponse.fromJson(Map<String, dynamic> json) => _$TextQueryResponseFromJson(json);
}