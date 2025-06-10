import 'package:flutter/material.dart';

import 'package:bread_place/config/di/locator.dart';
import 'package:bread_place/config/routing/router.dart';
import 'package:bread_place/domain/usecases/notification_use_case.dart';
import 'package:bread_place/ui/login/bloc/login_bloc.dart';
import 'data/services/local/user_local_storage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  await _initEnvFile();
  await UserLocalStorage.init();
  _initKakaoSdk();
  await _initFirebase();
  initLocator();
  _initLocalNotification();
}

Future<void> _initEnvFile() async {
  await dotenv.load(fileName: ".env");
}

void _initKakaoSdk() {
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']);
}

Future<void> _initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> _initLocalNotification() async {
  final instance = di<NotificationUseCase>();
  await instance.initService();
}