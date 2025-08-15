import 'package:bread_place/config/constants/exception/login_exception.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLoginService {
  Future<String> loginWithApple() async {
    // 로그인 진행
    final result = await SignInWithApple.getAppleIDCredential(
      scopes: [ AppleIDAuthorizationScopes.email ],
    );

    final uid = result.userIdentifier;

    // 로그인 실패한 경우 (UID를 가져오지 못함)
    if(uid == null){
      throw LoginFailedException();
    }

    return uid;
  }
}