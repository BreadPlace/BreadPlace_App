abstract class UserLocationRepository {
  Future<({double latitude, double longitude})>getUserLocation();
}