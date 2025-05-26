import 'package:json_annotation/json_annotation.dart';

part 'search_nearby_request.g.dart';

@JsonSerializable()
class SearchNearbyRequest {
  final List<String> includedTypes;
  final LocationRestriction locationRestriction;

  SearchNearbyRequest({
    required this.includedTypes,
    required this.locationRestriction,
  });

  factory SearchNearbyRequest.fromJson(Map<String, dynamic> json) => _$SearchNearbyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SearchNearbyRequestToJson(this);
}

@JsonSerializable()
class LocationRestriction {
  final Circle circle;

  LocationRestriction({required this.circle});

  factory LocationRestriction.fromJson(Map<String, dynamic> json) => _$LocationRestrictionFromJson(json);

  Map<String, dynamic> toJson() => _$LocationRestrictionToJson(this);
}

@JsonSerializable()
class Circle {
  final Center center;
  final double radius;

  Circle({required this.center, required this.radius});

  factory Circle.fromJson(Map<String, dynamic> json) => _$CircleFromJson(json);

  Map<String, dynamic> toJson() => _$CircleToJson(this);
}

@JsonSerializable()
class Center {
  final double latitude;
  final double longitude;

  Center({required this.latitude, required this.longitude});

  factory Center.fromJson(Map<String, dynamic> json) => _$CenterFromJson(json);

  Map<String, dynamic> toJson() => _$CenterToJson(this);
}
