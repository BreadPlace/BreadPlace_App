import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:mocktail/mocktail.dart';



// 외부 SDK를 직접 쓰지 않고, 테스트 가능한 인터페이스(추상 클래스)로 분리함
abstract class KakaoUserApi {
  Future<bool> isKakaoTalkInstalled();
  Future<OAuthToken> loginWithKakaoTalk();
  Future<OAuthToken> loginWithKakaoAccount();
}

// 위 인터페이스를 mocktail로 모킹함. 실제 SDK 없이 테스트 가능.
class MockKakaoUserApi extends Mock implements KakaoUserApi {}

class FakeOAuthToken extends Fake implements OAuthToken {}

// 테스트하려는 핵심 로직.
// 외부 의존성(Kakao SDK)을 받지 않음.
// KakaoUserApi 를 구현한 클래스는 모두 매개변수로 받을 수 있음.
// = 진짜 실행되는 SDK 인지, Mock SDK 인지 상관없이 받을 수 있다는 뜻.
Future<void> login(KakaoUserApi service) async {

  /// 카카오톡 앱이 설치 되어있는 경우
  if (await service.isKakaoTalkInstalled()) {
    try {
      await service.loginWithKakaoTalk();
      print('카카오톡 앱으로 로그인 성공');
    } catch (error) {
      print('카카오톡 앱으로 로그인 실패: $error');

      // 사용자가 로그인 취소한 경우 → 아무 것도 하지 않음
      if (error is PlatformException && error.code == 'CANCELED') return;

      // 그 외 실패 -> '카카오 계정으로 로그인' 시도
      try {
        await service.loginWithKakaoAccount();
        print('카카오 계정으로 로그인 성공');
      } catch (error) {
        print('카카오 계정으로 로그인 실패: $error');
      }
    }
  } else {
    /// 카카오톡 앱이 설치 되어 있지 않은 경우
    try {
      await service.loginWithKakaoAccount();
      print('카카오 계정으로 로그인 성공');
    } catch (error) {
      print('카카오 계정으로 로그인 실패: $error');
    }
  }
}

void main() {
  late MockKakaoUserApi mockApi;

  setUpAll(() {
    registerFallbackValue(FakeOAuthToken());
  });

  // 각 테스트마다 mock 객체 초기화
  setUp(() {
    mockApi = MockKakaoUserApi();
  });

  test('카카오톡 앱이 설치되어있는 상태에서 로그인 성공', () async {
    // 카카오톡 설치되어 있다고 가정
    when(() => mockApi.isKakaoTalkInstalled()).thenAnswer((_) async => true);

    // 로그인 성공
    when(() => mockApi.loginWithKakaoTalk()).thenAnswer((_)  async => FakeOAuthToken());
    

  });
}




