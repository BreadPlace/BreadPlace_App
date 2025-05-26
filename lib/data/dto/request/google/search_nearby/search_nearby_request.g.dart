// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_nearby_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchNearbyRequest _$SearchNearbyRequestFromJson(Map<String, dynamic> json) =>
    SearchNearbyRequest(
      includedTypes:
          (json['includedTypes'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      locationRestriction: LocationRestriction.fromJson(
        json['locationRestriction'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$SearchNearbyRequestToJson(
  SearchNearbyRequest instance,
) => <String, dynamic>{
  'includedTypes': instance.includedTypes,
  'locationRestriction': instance.locationRestriction,
};

LocationRestriction _$LocationRestrictionFromJson(Map<String, dynamic> json) =>
    LocationRestriction(
      circle: Circle.fromJson(json['circle'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LocationRestrictionToJson(
  LocationRestriction instance,
) => <String, dynamic>{'circle': instance.circle};

Circle _$CircleFromJson(Map<String, dynamic> json) => Circle(
  center: Center.fromJson(json['center'] as Map<String, dynamic>),
  radius: (json['radius'] as num).toDouble(),
);

Map<String, dynamic> _$CircleToJson(Circle instance) => <String, dynamic>{
  'center': instance.center,
  'radius': instance.radius,
};

Center _$CenterFromJson(Map<String, dynamic> json) => Center(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
);

Map<String, dynamic> _$CenterToJson(Center instance) => <String, dynamic>{
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
