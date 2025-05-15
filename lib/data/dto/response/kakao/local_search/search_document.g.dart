// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchDocument _$SearchDocumentFromJson(Map<String, dynamic> json) =>
    SearchDocument(
      id: json['id'] as String,
      placeName: json['place_name'] as String,
      categoryName: json['category_name'] as String,
      categoryGroupCode: json['category_group_code'] as String,
      categoryGroupName: json['category_group_name'] as String,
      phone: json['phone'] as String,
      addressName: json['address_name'] as String,
      roadAddressName: json['road_address_name'] as String,
      x: json['x'] as String,
      y: json['y'] as String,
      placeUrl: json['place_url'] as String,
      distance: json['distance'] as String,
    );

Map<String, dynamic> _$SearchDocumentToJson(SearchDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'place_name': instance.placeName,
      'category_name': instance.categoryName,
      'category_group_code': instance.categoryGroupCode,
      'category_group_name': instance.categoryGroupName,
      'phone': instance.phone,
      'address_name': instance.addressName,
      'road_address_name': instance.roadAddressName,
      'x': instance.x,
      'y': instance.y,
      'place_url': instance.placeUrl,
      'distance': instance.distance,
    };
