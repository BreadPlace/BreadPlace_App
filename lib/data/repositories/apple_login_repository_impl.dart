import 'package:bread_place/config/constants/exception/login_exception.dart';
import 'package:bread_place/data/services/login/apple_login_service.dart';
import 'package:bread_place/domain/repositories/apple_login_repository.dart';

class AppleLoginRepositoryImpl implements AppleLoginRepository {
  final AppleLoginService _service;

  AppleLoginRepositoryImpl({ required AppleLoginService appleLoginService})
  : _service = appleLoginService;

  @override
  Future<String> loginWithAppleAndGetUID() async {
    try {
      final uid = await _service.loginWithApple();
      return uid;
    } catch(error) {
      throw LoginFailedException();
    }
  }
}