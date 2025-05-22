import 'package:json_annotation/json_annotation.dart';
import 'location.dart';

part 'view_port.g.dart';

@JsonSerializable()
class ViewportDto {
  final LocationDto low;
  final LocationDto high;

  ViewportDto({required this.low, required this.high});

  factory ViewportDto.fromJson(Map<String, dynamic> json) => _$ViewportDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ViewportDtoToJson(this);
}
