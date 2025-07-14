import 'package:bread_place/domain/entities/user_entity.dart';
import 'package:bread_place/domain/repositories/firestore_repository.dart';
import 'package:bread_place/domain/repositories/google_login_repository.dart';
import 'package:bread_place/domain/repositories/kakao_login_repository.dart';
import 'package:bread_place/domain/repositories/user_local_storage_repository.dart';

class LoginUseCase {
  final FirestoreRepository _firestoreRepository;
  final UserLocalStorageRepository _userLocalStorageRepository;
  final KakaoLoginRepository _kakaoLoginRepository;
  final GoogleLoginRepository _googleLoginRepository;

  LoginUseCase({
    required FirestoreRepository firestoreRepository,
    required UserLocalStorageRepository userLocalStorageRepository,
    required KakaoLoginRepository kakaoLoginRepository,
    required GoogleLoginRepository googleLoginReposiory,
  })
      : _firestoreRepository = firestoreRepository,
        _userLocalStorageRepository = userLocalStorageRepository,
        _kakaoLoginRepository = kakaoLoginRepository,
        _googleLoginRepository = googleLoginReposiory;

  Future<String> loginWithKakaoAndGetUID() async {
    // 로그인 & 성공 시 UID 가져오기
    final uid = await _kakaoLoginRepository.loginWithKakaoAndGetUID();

    // 로컬 저장
    await _userLocalStorageRepository.saveUserId(uid);

    return uid;
  }

  Future<String> loginWithGoogleAndGetUID() async {
    // 로그인 & 성공 시 UID 가져오기
    final uid = await _googleLoginRepository.loginWithGoogleAndGetUID();

    // 로컬 저장
    await _userLocalStorageRepository.saveUserId(uid);

    return uid;
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
}