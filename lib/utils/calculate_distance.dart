import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

double getDistanceKM(LatLng from, LatLng to) {
  double distance = Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude
  );

  double distanceInKm = distance / 1000;
  return double.parse(distanceInKm.toStringAsFixed(2));
}

LatLng getCenterLatLng(LatLngBounds bounds) {
  return LatLng(
      (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
      (bounds.northeast.longitude + bounds.southwest.longitude) / 2
  );
}