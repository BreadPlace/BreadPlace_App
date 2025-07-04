import 'package:bread_place/domain/entities/liked_bakery_entity.dart';
import 'package:bread_place/domain/repositories/firestore_repository.dart';
import 'package:bread_place/domain/repositories/user_local_storage_repository.dart';

class LikedBakeryUseCase {
  final FirestoreRepository _firestoreRepo;
  final UserLocalStorageRepository _userLocalStorage;

  LikedBakeryUseCase({
    required FirestoreRepository firestoreRepo,
    required UserLocalStorageRepository userLocalStorage,
  }) : _firestoreRepo = firestoreRepo,
       _userLocalStorage = userLocalStorage;


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
    return likedBakeries;
  }
}
