import 'package:bread_place/config/constants/app_constants.dart';
import 'package:bread_place/data/services/api/google/google_place_api.dart';
import 'package:bread_place/data/services/api/google/google_place_dio_client.dart';
import 'package:bread_place/data/services/api/kakao/kakao_dio_client.dart';
import 'package:bread_place/data/services/api/kakao/kakao_local_api.dart';
import 'package:bread_place/data/services/image/image_compress_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

void registerUtil(GetIt di) {
  // 이미지 압축 유틸 서비스
  di.registerLazySingleton<ImageCompressService>(() => ImageCompressService());

  // 카카오 환경 설정
  di.registerLazySingleton<KakaoDioClient>(() => KakaoDioClient());
  di.registerLazySingleton<KakaoLocalApi>(() => KakaoLocalApi(di<KakaoDioClient>().dio));

  // 구글 플레이스
  di.registerLazySingleton<GooglePlaceDioClient>(() => GooglePlaceDioClient());
  di.registerLazySingleton<GooglePlaceApi>(() => GooglePlaceApi(di<GooglePlaceDioClient>().dio));

  // 알림 환경 설정
  di.registerLazySingleton<FlutterLocalNotificationsPlugin>(() => FlutterLocalNotificationsPlugin());

  // 지오펜스 메서드 채널
  di.registerSingleton<MethodChannel>(
      MethodChannel(AppConstants.geofencingChannelName),
      instanceName: AppConstants.geofencingChannelName
  );

  // 지오펜스 이벤트 채널
  di.registerSingleton<EventChannel>(
      EventChannel(AppConstants.geofencingEventChannelName),
      instanceName: AppConstants.geofencingEventChannelName
  );
}