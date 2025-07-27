// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend_bakery_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendBakeryDto _$RecommendBakeryDtoFromJson(Map<String, dynamic> json) =>
    RecommendBakeryDto(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      random: (json['random'] as num).toDouble(),
    );

Map<String, dynamic> _$RecommendBakeryDtoToJson(RecommendBakeryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'random': instance.random,
    };
