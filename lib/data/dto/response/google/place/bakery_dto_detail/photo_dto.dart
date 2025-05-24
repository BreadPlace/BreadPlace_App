import 'package:json_annotation/json_annotation.dart';

part 'photo_dto.g.dart';

@JsonSerializable()
class PhotoDto {
  final String? name;

  PhotoDto({this.name});

  factory PhotoDto.fromJson(Map<String, dynamic> json) => _$PhotoDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoDtoToJson(this);
}