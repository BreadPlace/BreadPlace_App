import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommend_bakery_dto.g.dart';

@JsonSerializable()
class RecommendBakeryDto{
  final String id;
  final String name;
  final double random;

  RecommendBakeryDto({
    required this.id,
    required this.name,
    required this.random,
  });

  factory RecommendBakeryDto.fromJson(Map<String, dynamic> json) => _$RecommendBakeryDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendBakeryDtoToJson(this);
}