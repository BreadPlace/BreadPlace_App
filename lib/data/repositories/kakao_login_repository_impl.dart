import 'package:bread_place/config/constants/exception/login_exception.dart';
import 'package:bread_place/data/services/login/kakao_login_service.dart';
import 'package:bread_place/domain/repositories/kakao_login_repository.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginRepositoryImpl implements KakaoLoginRepository {
  final KakaoLoginService _service;

  KakaoLoginRepositoryImpl({required KakaoLoginService kakaoLoginService})
  : _service = kakaoLoginService;

  Future<String> loginWithKakaoAndGetUID() async {
    bool isKakaoTalkAvailable = await _service.checkIsKakaoTalkInstalled();

    try {
      // 로그인 시도
      isKakaoTalkAvailable
          ? await _service.loginWithKakaoTalk()
          : await _service.loginWithKakaoAccount();

      final userInfo = await UserApi.instance.me();
      final uid = userInfo.id.toString();

      return uid;
    } on PlatformException catch (error) {
      // 사용자가 로그인을 취소한 경우
      if(error.code == 'CANCELED'){
        throw LoginCanceldException();
      } else {
        throw LoginFailedException();
      }
    } catch (error) {
      throw LoginFailedException();
    }
  }
}