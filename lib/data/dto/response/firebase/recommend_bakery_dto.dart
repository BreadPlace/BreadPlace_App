import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommend_bakery_dto.g.dart';

@JsonSerializable()
class RecommendBakeryDto{
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double random;

  RecommendBakeryDto({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.random,
  });

  factory RecommendBakeryDto.fromJson(Map<String, dynamic> json) => _$RecommendBakeryDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendBakeryDtoToJson(this);
}