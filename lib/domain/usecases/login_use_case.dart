import 'package:bread_place/config/constants/app_enum/app_social_platform.dart';
import 'package:bread_place/domain/entities/liked_bakery_entity.dart';
import 'package:bread_place/domain/entities/user_entity.dart';
import 'package:bread_place/domain/repositories/apple_login_repository.dart';
import 'package:bread_place/domain/repositories/firestore_repository.dart';
import 'package:bread_place/domain/repositories/geofencing_repository.dart';
import 'package:bread_place/domain/repositories/google_login_repository.dart';
import 'package:bread_place/domain/repositories/kakao_login_repository.dart';
import 'package:bread_place/domain/repositories/user_local_storage_repository.dart';

class LoginUseCase {
  final FirestoreRepository _firestoreRepository;
  final UserLocalStorageRepository _userLocalStorageRepository;
  final KakaoLoginRepository _kakaoLoginRepository;
  final GoogleLoginRepository _googleLoginRepository;
  final AppleLoginRepository _appleLoginRepository;
  final GeofencingRepository _geofencingRepository;

  LoginUseCase({
    required FirestoreRepository firestoreRepository,
    required UserLocalStorageRepository userLocalStorageRepository,
    required KakaoLoginRepository kakaoLoginRepository,
    required GoogleLoginRepository googleLoginRepository,
    required AppleLoginRepository appleLoginRepository,
    required GeofencingRepository geofencingRepository,
  })
      : _firestoreRepository = firestoreRepository,
        _userLocalStorageRepository = userLocalStorageRepository,
        _kakaoLoginRepository = kakaoLoginRepository,
        _googleLoginRepository = googleLoginRepository,
        _appleLoginRepository = appleLoginRepository,
        _geofencingRepository = geofencingRepository;

  Future<String> loginAndGetUID(AppSocialPlatform platform) async {
    String uid;

    switch(platform) {
      case AppSocialPlatform.kakao:
        uid = await _kakaoLoginRepository.loginWithKakaoAndGetUID();
        break;
      case AppSocialPlatform.google:
        uid = await _googleLoginRepository.loginWithGoogleAndGetUID();
        break;
      case AppSocialPlatform.apple:
        uid = await _appleLoginRepository.loginWithAppleAndGetUID();
        break;
    }

    // 로컬 저장
    await _userLocalStorageRepository.saveUserId(uid);

    // 알람을 허용한 베이커리 로컬, 지오펜스 재등록
    final locations = (await _firestoreRepository.fetchLikedBakeries(uid))
        .where((likedBakery) => likedBakery.isNotificationAllowed == true)
        .toList()
        .toGeofenceLocationString;

    await _userLocalStorageRepository.saveGeofencingLocations(locations);
    await _geofencingRepository.setGeofencingLocations(locations);

    return uid;
  }

  Future<void> logout() async {
    // 로컬에 등록된 유저 데이터 삭제하기 (UID, 닉네임, 가입일)
    _userLocalStorageRepository.removeUserData();

    // 로컬에 등록된 로컬 지오펜스 삭제하기
    _userLocalStorageRepository.removeGeofencingLocationAll();

    // 네이티브에 등록된 지오펜스 삭제하기
    _geofencingRepository.stopGeofencingLocations();
  }

  Future<void> withDraw() async {
    // 로컬에 등록된 유저 UID 가져오기
    final uid = await _userLocalStorageRepository.getUserId();

    print("uid:        $uid");

    if(uid != null) {
      // 서버의 모든 유저 데이터 삭제
      await _firestoreRepository.deleteAllUserInfo(uid);

      print("uid:        $uid");

      // 로그아웃 진행(로컬 데이터 삭제)
      await logout();
    }
  }

  Future<UserEntity?> getUserDataByUid(String uid) async {
    try {
      final userData = await _firestoreRepository.fetchUserDataByUid(uid);
      return userData;
    } catch (e) {
      print('getUserDataByUid 에러 $e');
      return null;
    }
  }

  Future<void> updateUserNickname(UserEntity user) async {
    await _firestoreRepository.updateUserNickname(user);
    await _userLocalStorageRepository.saveUserNickname(user.nickname);
  }

  Future<void> saveNewUser(UserEntity user) async {
    await _firestoreRepository.saveUser(user);
    await _userLocalStorageRepository.saveUserData(user);
  }
}