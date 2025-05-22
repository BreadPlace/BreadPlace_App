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
  final String languageCode;
  final String formattedAddress;

  @JsonKey(name: 'nationalPhoneNumber')
  final String formattedPhoneNumber;

  @JsonKey(name: 'googleMapsUri')
  final String uri;

  @JsonKey(defaultValue: [])
  final List<String> types;

  final DisplayName displayName;
  final LocationDto location;
  final ViewportDto viewPort;
  final PlusCodeDto plusCode;
  final PhotoDto photos;

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