import 'package:json_annotation/json_annotation.dart';

part 'plus_code.g.dart';

@JsonSerializable()
class PlusCodeDto {
  final String globalCode;
  final String compoundCode;

  PlusCodeDto({required this.globalCode, required this.compoundCode});

  factory PlusCodeDto.fromJson(Map<String, dynamic> json) => _$PlusCodeDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PlusCodeDtoToJson(this);
}
