import 'package:bread_place/config/constants/exception/login_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginService {
  Future<void> loginWithGoogle() async {
    // 스코프 적용
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

    // 로그인 진행
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    // 로그인을 취소한 경우
    if(googleUser == null){
      throw LoginCanceldException();
    }

    // 받아 온 계정 정보로 파이어베이스에 로그인 진행
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);

    return;
  }
}