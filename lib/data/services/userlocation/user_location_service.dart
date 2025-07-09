import 'package:geolocator/geolocator.dart';

class UserLocationService {
  Future<({double latitude, double longitude})>getUserLocation() async {
    final currentPosition = await Geolocator.getCurrentPosition();
    return(latitude: currentPosition.latitude, longitude: currentPosition.longitude);
  }
}