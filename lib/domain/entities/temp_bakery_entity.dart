import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class TempBakeryEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final LatLng location;
  final String imagePath;

  const TempBakeryEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.imagePath,
  });

  static const empty = TempBakeryEntity(
    id: '',
    name: '',
    address: '',
    location: LatLng(0, 0),
    imagePath: 'assets/images/Croissant.png',
  );

  @override
  List<Object?> get props => [id, name, address, location];
}

extension TempBakeryDistanceExtension on TempBakeryEntity {
  double distanceFromUser(LatLng userLocation) {
    double distance = Geolocator.distanceBetween(
      location.latitude,
      location.longitude,
      userLocation.latitude,
      userLocation.longitude,
    );

    double distanceInKm = distance / 1000;
    return double.parse(distanceInKm.toStringAsFixed(2));
  }
}
