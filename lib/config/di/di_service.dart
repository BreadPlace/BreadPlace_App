import 'package:bread_place/config/constants/app_constants.dart';
import 'package:bread_place/data/services/firebase/firestore_service.dart';
import 'package:bread_place/data/services/geofencing/geofencing_service.dart';
import 'package:bread_place/data/services/local/user_local_storage.dart';
import 'package:bread_place/data/services/login/google_login_service.dart';
import 'package:bread_place/data/services/login/kakao_login_service.dart';
import 'package:bread_place/data/services/notification/local_notification_service.dart';
import 'package:bread_place/data/services/permission/permission_service.dart';
import 'package:bread_place/data/services/userlocation/user_location_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

void registerService(GetIt di) {
  // Kakao Login
  di.registerLazySingleton<KakaoLoginService>(() => KakaoLoginService());
  // Google Login
  di.registerLazySingleton<GoogleLoginService>(() => GoogleLoginService());

  // 파이어 베이스
  di.registerLazySingleton<FirestoreService>(() => FirestoreService(FirebaseFirestore.instance));

  // 사용자 위치
  di.registerSingletonAsync<UserLocationService>(() async {
    final service = UserLocationService();
    return service;
  });

  // 로컬 저장소
  di.registerSingletonAsync<UserLocalStorageService>(() async {
    final service = UserLocalStorageService();
    await service.init();
    return service;
  });

  // 로컬 알림
  di.registerLazySingleton<LocalNotificationService>(() => LocalNotificationService(di<FlutterLocalNotificationsPlugin>()));

  // GeofencingLocations
  di.registerSingletonAsync<GeofencingService>(() async {
    final service = GeofencingService(
      geofencingChannel: di<MethodChannel>(
          instanceName: AppConstants.geofencingChannelName),
      geofencingEventChannel: di<EventChannel>(
          instanceName: AppConstants.geofencingEventChannelName),
    );

    await service.init();
    return service;
  });

  // 권한
  di.registerLazySingleton<PermissionService>(() => PermissionService());
}




