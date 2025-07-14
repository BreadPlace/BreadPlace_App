import 'package:bread_place/config/constants/exception/login_exception.dart';
import 'package:bread_place/data/services/login/google_login_service.dart';
import 'package:bread_place/domain/repositories/google_login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleLoginRepositoryImpl implements GoogleLoginRepository {
  final GoogleLoginService _service;

  GoogleLoginRepositoryImpl({required GoogleLoginService googleLoginService})
    : _service = googleLoginService;

  @override
  Future<String> loginWithGoogleAndGetUID() async {
    await _service.loginWithGoogle();
    final uid = FirebaseAuth.instance.currentUser?.uid;

    // 로그인에 실패한 경우
    if (uid == null) {
      throw LoginFailedException();
    }

    return uid;
  }
}