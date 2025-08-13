import 'package:flutter/material.dart';

import 'package:bread_place/config/di/locator.dart';
import 'package:bread_place/config/routing/router.dart';
import 'package:bread_place/domain/usecases/notification_use_case.dart';
import 'package:bread_place/ui/login/bloc/login_bloc.dart';
import 'package:bread_place/domain/usecases/user_local_storage_use_case.dart';
import 'package:bread_place/ui/home/bloc/home_bloc.dart';
import 'package:bread_place/ui/like/bloc/like_bloc.dart';
import 'package:bread_place/ui/like/bloc/like_event.dart';
import 'package:bread_place/ui/permission/bloc/permission_bloc.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeApp();

  runApp(MyApp(isFirstLaunch: await isFirstLaunch()));
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;
  
  const MyApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di<LoginBloc>()),
        BlocProvider(create: (_) => di<LikeBloc>()..add(FetchLikedBakeries())),
        BlocProvider(create: (_) => di<HomeBloc>()..add(HomeAppInitiate())),
        BlocProvider(create: (_) => di<PermissionBloc>())
      ],
      child: MaterialApp.router(
        title: 'BreadPlace',
        themeMode: ThemeMode.light,
        routerConfig: createRouter(isFirstLaunch: isFirstLaunch),
      ),
    );
  }
}

Future<void> _initializeApp() async {
  await _initEnvFile();
  _initKakaoSdk();
  await _initFirebase();
  await _initDependencies();
  _initLocalNotification();
}

Future<void> _initDependencies() async {
  initLocator();
  await di.allReady(); // 비동기 의존성 준비 완료될 때까지 대기
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

Future<bool> isFirstLaunch() async {
  return await di<UserLocalStorageUseCase>().isFirstLaunch();
}