import 'package:flutter/material.dart';

import 'package:bread_place/config/routing/router.dart';
import 'package:bread_place/ui/login/bloc/login_bloc.dart';
import 'package:bread_place/config/di/locator.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';


void main() async {
  await dotenv.load(fileName: ".env");

  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']
  );

  initLocator();
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
