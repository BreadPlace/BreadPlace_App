import 'package:bread_place/config/constants/exception/app_permission_exception.dart';
import 'package:bread_place/domain/entities/app_permission.dart';
import 'package:bread_place/domain/repositories/permission_repository.dart';
import 'package:bread_place/domain/repositories/user_location_repository.dart';

class UserLocationUseCase {
  final UserLocationRepository _userLocationRepository;
  final PermissionRepository _permissionRepository;

  UserLocationUseCase({
    required UserLocationRepository userLocationRepository,
    required PermissionRepository permissionRepository,
  }) : _userLocationRepository = userLocationRepository,
       _permissionRepository = permissionRepository;

  Future<({double latitude, double longitude})>getUserLocation() async {
    final permissionStatus = await _permissionRepository.getPermissionStatus(AppPermission.location);

    if(permissionStatus != AppPermissionStatus.granted){
      throw AppPermissionDeniedException();
    }

    return _userLocationRepository.getUserLocation();
  }
}