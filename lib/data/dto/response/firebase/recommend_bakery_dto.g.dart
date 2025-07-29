// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend_bakery_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendBakeryDto _$RecommendBakeryDtoFromJson(Map<String, dynamic> json) =>
    RecommendBakeryDto(
      id: json['id'] as String,
      name: json['name'] as String,
      random: (json['random'] as num).toDouble(),
    );

Map<String, dynamic> _$RecommendBakeryDtoToJson(RecommendBakeryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'random': instance.random,
    };
