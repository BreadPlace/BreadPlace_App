import 'package:bread_place/data/dto/response/google/place/bakery_dto_detail/location.dart';
import 'package:bread_place/data/dto/response/google/place/bakery_dto_detail/photo_dto.dart';
import 'package:bread_place/data/dto/response/google/place/bakery_dto_detail/plus_code.dart';
import 'package:bread_place/data/dto/response/google/place/bakery_dto_detail/view_port.dart';
import 'package:json_annotation/json_annotation.dart';
import 'bakery_dto_detail/display_name.dart';

part 'bakery_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class BakeryDto {
  final String id;
  final String? formattedAddress;

  @JsonKey(name: 'googleMapsUri')
  final String? uri;

  @JsonKey(name: 'nationalPhoneNumber')
  final String? formattedPhoneNumber;

  @JsonKey(defaultValue: [])
  final List<String> types;

  final DisplayName? displayName;
  final LocationDto? location;
  final ViewportDto? viewPort;
  final PlusCodeDto? plusCode;
  final List<PhotoDto>? photos;

  BakeryDto({
    required this.id,
    required this.types,
    this.formattedAddress,
    this.uri,
    this.formattedPhoneNumber,
    this.displayName,
    this.location,
    this.viewPort,
    this.plusCode,
    this.photos,
  });

  factory BakeryDto.fromJson(Map<String, dynamic> json) => _$BakeryDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BakeryDtoToJson(this);
}