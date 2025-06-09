import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:bread_place/config/routing/router.dart';
import 'package:bread_place/ui/login/bloc/login_bloc.dart';
import 'package:bread_place/config/di/locator.dart';
import 'data/services/firebase/fcm_notification_service.dart';
import 'data/services/local/user_local_storage.dart';
import 'package:bread_place/data/services/notification/local_notification_service.dart';

import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await _initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di<LoginBloc>(),
      child: MaterialApp.router(
        title: 'BreadPlace',
        themeMode: ThemeMode.light,
        routerConfig: router,
      ),
    );
  }
}

Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initEnvFile();
  await UserLocalStorage.init();
  _initKakaoSdk();
  await _initFirebase();
  initLocator();
  _initLocalNotification();

  // main 함수에서도 한번, 핸들러에서도 한번 총 두번 초기화가 일어납니다.
  // await _initFcmNotification();
}

Future<void> _initEnvFile() async {
  await dotenv.load(fileName: ".env");
}

void _initKakaoSdk() {
  KakaoSdk.init(
      nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']
  );
}

Future<void> _initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> _initLocalNotification() async {
  await LocalNotificationService.init();
}

// fcm
// Future<void> _initFcmNotification() async {
//   final fcmService = FcmNotificationService();
//   await fcmService.requestPermission(); // 알림 권한 요청
//
//   fcmService.getFcmToken();
//   fcmService.setupForegroundMessaging();
// }