import 'package:json_annotation/json_annotation.dart';

part 'liked_bakery_dto.g.dart';

@JsonSerializable()
class LikedBakeryDto {
  final String bakeryId;
  final bool isNotify;
  final String updatedAt;
  final String displayName;
  final String? address;
  final String? locationLat;
  final String? locationLong;

  LikedBakeryDto({
    required this.bakeryId,
    required this.isNotify,
    required this.updatedAt,
    required this.displayName,
    required this.address,
    required this.locationLat,
    required this.locationLong,
  });

  factory LikedBakeryDto.fromJson(Map<String, dynamic> json) => _$LikedBakeryDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LikedBakeryDtoToJson(this);
}
