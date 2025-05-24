import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class LocationDto {
  final double? latitude;
  final double? longitude;

  LocationDto({this.latitude, this.longitude});

  factory LocationDto.fromJson(Map<String, dynamic> json) => _$LocationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LocationDtoToJson(this);
}