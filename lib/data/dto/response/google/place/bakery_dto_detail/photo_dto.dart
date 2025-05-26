import 'package:bread_place/data/dto/response/google/place/bakery_dto_detail/author_attribution.dart';
import 'package:json_annotation/json_annotation.dart';

part 'photo_dto.g.dart';

@JsonSerializable()
class PhotoDto {
  final String? name;
  final int? widthPx;
  final int? heightPx;

  @JsonKey(defaultValue: [])
  final List<AuthorAttribution> authorAttributions; // 저작자 표시

  PhotoDto(this.name, this.widthPx, this.heightPx, this.authorAttributions);

  factory PhotoDto.fromJson(Map<String, dynamic> json) => _$PhotoDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoDtoToJson(this);
}