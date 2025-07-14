import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginService {
  Future<bool> checkIsKakaoTalkInstalled() async {
    return await isKakaoTalkInstalled();
  }

  Future<void> loginWithKakaoTalk() async {
    await UserApi.instance.loginWithKakaoTalk();
  }

  Future<void> loginWithKakaoAccount() async {
    await UserApi.instance.loginWithKakaoAccount();
  }
}