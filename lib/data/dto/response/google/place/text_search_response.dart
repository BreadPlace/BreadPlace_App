import 'package:bread_place/data/dto/response/google/place/bakery_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'text_search_response.g.dart';

@JsonSerializable()
class TextSearchResponse {
  @JsonKey(name: 'places', defaultValue: [])
  final List<BakeryDto> bakeries;

  TextSearchResponse({required this.bakeries});

  factory TextSearchResponse.fromJson(Map<String, dynamic> json) => _$TextSearchResponseFromJson(json);
}