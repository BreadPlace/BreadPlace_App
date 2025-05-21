import 'package:json_annotation/json_annotation.dart';
import 'display_name.dart';

part 'bakery_dto.g.dart';

@JsonSerializable()
class BakeryDto {
  final DisplayName displayName;
  final String formattedAddress;

  BakeryDto({required this.displayName, required this.formattedAddress});

  factory BakeryDto.fromJson(Map<String, dynamic> json) => _$BakeryDtoFromJson(json);
}