import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RecommendBakeryEntity {
  final String bakeryId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  RecommendBakeryEntity({
    required this.bakeryId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude
  });
}

extension BakeryDistanceExtension on RecommendBakeryEntity {
  double distanceFromUser(LatLng userLocation) {
    double distance = Geolocator.distanceBetween(
      latitude,
      longitude,
      userLocation.latitude,
      userLocation.longitude,
    );

    double distanceInKm = distance / 1000;
    return double.parse(distanceInKm.toStringAsFixed(2));
  }
}