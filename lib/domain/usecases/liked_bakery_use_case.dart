import 'package:bread_place/domain/entities/app_permission.dart';
import 'package:bread_place/domain/entities/liked_bakery_entity.dart';
import 'package:bread_place/domain/repositories/firestore_repository.dart';
import 'package:bread_place/domain/repositories/permission_repository.dart';
import 'package:bread_place/domain/repositories/user_local_storage_repository.dart';

class LikedBakeryUseCase {
  final FirestoreRepository _firestoreRepo;
  final UserLocalStorageRepository _userLocalStorage;
  final PermissionRepository _permissionRepository;

  LikedBakeryUseCase({
    required FirestoreRepository firestoreRepo,
    required UserLocalStorageRepository userLocalStorage,
    required PermissionRepository permissionRepo,
  }) : _firestoreRepo = firestoreRepo,
       _userLocalStorage = userLocalStorage,
       _permissionRepository = permissionRepo;

  Future<String> getUserId() async {
    final userId = await _userLocalStorage.getUserId();
    if (userId == null) {
      throw Exception('[LikedBakeryUseCase] userId가 null입니다. 로그인 상태를 확인하세요.');
    } else {
      return userId;
    }
  }

  Future<void> addLike(LikedBakeryEntity likedBakery, bool isNotificationAllowed) async {
    final userId = await getUserId();
    await _firestoreRepo.addLiked(userId, likedBakery, isNotificationAllowed);
  }

  Future<void> removeLike(String bakeryId) async {
    final userId = await getUserId();
    await _firestoreRepo.removeLiked(userId, bakeryId);
  }


  /// 사용자가 좋아요를 누른 베이커리 목록을 조회
  Future<List<LikedBakeryEntity>> fetchLikedBakeriesWithDetails() async {
    final userId = await getUserId();

    final likedBakeries = await _firestoreRepo.fetchLikedBakeries(userId);

    if (likedBakeries.isNotEmpty) {
      final locations = _getAllowedBakeryLocations(likedBakeries);
      await _userLocalStorage.saveGeofencingLocations(locations);
    }

    return likedBakeries;
  }

  Future<void> _ensureRequiredPermissionsGranted() async {
    await _permissionRepository.ensurePermissionGranted(
      AppPermission.locationAlways,
    );
    await _permissionRepository.ensurePermissionGranted(
      AppPermission.notification,
    );
  }

  /// 해당 베이커리의 알림 설정 여부를 토글하여 서버에 업데이트
  Future<bool> updateIsNotificationAllowed(
    String bakeryId,
    bool newState,
  ) async {
    _ensureRequiredPermissionsGranted();

    final userId = await getUserId();
    bool result = await _firestoreRepo.toggleBakeryNotification(
      userId,
      bakeryId,
      newState,
    );
    return result;
  }

  /// 알림 허용된 베이커리들의 위치 정보를 추출하여 문자열 리스트로 변환
  List<String> _getAllowedBakeryLocations(List<LikedBakeryEntity> likedBakeries) {
    return likedBakeries
        .where((liked) => liked.isNotificationAllowed == true)
        .map((allowed) {
      final lat = allowed.bakery?.location.latitude;
      final lng = allowed.bakery?.location.longitude;

      if (lat != null && lng != null) {
        return "$lat, $lng";
      } return null;
    }).whereType<String>().toList(); // 위치 정보 null 인 베이커리는 제외하고 리턴
  }
}
