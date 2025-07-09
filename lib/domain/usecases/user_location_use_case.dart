import 'package:bread_place/domain/repositories/user_location_repository.dart';

class UserLocationUseCase {
  final UserLocationRepository _userLocationRepository;

  UserLocationUseCase({
    required UserLocationRepository userLocationRepository
  }): _userLocationRepository = userLocationRepository;

  Future<({double latitude, double longitude})>getUserLocation() async {
    // TODO: 권한 관련 처리는 추후 permissionRepository로 처리해야 합니다.
    // 권한 확인
    final hasPermission = true;

    if(!hasPermission){
      throw Exception("권한이 없어용");
    }

    return _userLocationRepository.getUserLocation();
  }
}