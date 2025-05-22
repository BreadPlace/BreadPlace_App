import 'package:json_annotation/json_annotation.dart';
import 'display_name.dart';

part 'bakery_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class BakeryDto {
  final DisplayName displayName;
  final String languageCode;
  final String formattedAddress;
  final String formattedPhoneNumber;
  final String location;
  final String viewPort;
  final String id;
  final String plusCode;

  @JsonKey(name: 'googleMapsUri')
  final String uri;

  @JsonKey(defaultValue: [])
  final List<String> types;

  @JsonKey(defaultValue: [])
  final List<String> photos;

  BakeryDto({
    required this.displayName,
    required this.languageCode,
    required this.formattedAddress,
    required this.formattedPhoneNumber,
    required this.location,
    required this.viewPort,
    required this.id,
    required this.plusCode,
    required this.uri,
    required this.types,
    required this.photos,
  });

  factory BakeryDto.fromJson(Map<String, dynamic> json) => _$BakeryDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BakeryDtoToJson(this);
}