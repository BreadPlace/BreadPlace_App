import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:bread_place/config/routing/router.dart';
import 'package:bread_place/ui/login/bloc/login_bloc.dart';
import 'package:bread_place/config/di/locator.dart';
import 'firebase_options.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';


void main() async {
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
  _initKakaoSdk();
  await _initFirebase();
  initLocator();
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