import 'package:bread_place/data/repositories/firestore_repository_impl.dart';
import 'package:bread_place/data/repositories/geofencing_repository_impl.dart';
import 'package:bread_place/data/repositories/google_login_repository_impl.dart';
import 'package:bread_place/data/repositories/google_place_repository_impl.dart';
import 'package:bread_place/data/repositories/kakao_login_repository_impl.dart';
import 'package:bread_place/data/repositories/kakao_search_repository_impl.dart';
import 'package:bread_place/data/repositories/notification_repository_impl.dart';
import 'package:bread_place/data/repositories/permission_repository_impl.dart';
import 'package:bread_place/data/repositories/user_local_storage_repository_impl.dart';
import 'package:bread_place/data/repositories/user_location_repository_impl.dart';
import 'package:bread_place/data/services/api/google/google_place_api.dart';
import 'package:bread_place/data/services/api/kakao/kakao_local_api.dart';
import 'package:bread_place/data/services/firebase/firestore_service.dart';
import 'package:bread_place/data/services/geofencing/geofencing_service.dart';
import 'package:bread_place/data/services/image/image_compress_service.dart';
import 'package:bread_place/data/services/local/user_local_storage.dart';
import 'package:bread_place/data/services/login/google_login_service.dart';
import 'package:bread_place/data/services/login/kakao_login_service.dart';
import 'package:bread_place/data/services/notification/local_notification_service.dart';
import 'package:bread_place/data/services/permission/permission_service.dart';
import 'package:bread_place/data/services/userlocation/user_location_service.dart';
import 'package:bread_place/domain/repositories/firestore_repository.dart';
import 'package:bread_place/domain/repositories/geofencing_repository.dart';
import 'package:bread_place/domain/repositories/google_login_repository.dart';
import 'package:bread_place/domain/repositories/google_place_repository.dart';
import 'package:bread_place/domain/repositories/kakao_login_repository.dart';
import 'package:bread_place/domain/repositories/kakao_search_repository.dart';
import 'package:bread_place/domain/repositories/notification_repository.dart';
import 'package:bread_place/domain/repositories/permission_repository.dart';
import 'package:bread_place/domain/repositories/user_local_storage_repository.dart';
import 'package:bread_place/domain/repositories/user_location_repository.dart';
import 'package:get_it/get_it.dart';

void registerRepository(GetIt di) {
  // Kakao Login
  di.registerSingletonAsync<KakaoLoginRepository>(() async {
    final kakaoLoginService = di<KakaoLoginService>();
    return KakaoLoginRepositoryImpl(kakaoLoginService: kakaoLoginService);
  });

  // 카카오 검색
  di.registerLazySingleton<KakaoSearchRepository>(() => KakaoSearchRepositoryImpl(kakaoLocalApi: di<KakaoLocalApi>()));

  // Google Login
  di.registerSingletonAsync<GoogleLoginRepository>(() async {
    final googleLoginService = di<GoogleLoginService>();
    return GoogleLoginRepositoryImpl(googleLoginService: googleLoginService);
  });

  // 구글 플레이스
  di.registerLazySingleton<GooglePlaceRepository>(() => GooglePlaceRepositoryImpl(googlePlaceApi: di<GooglePlaceApi>()));

  // 파이어 베이스
  di.registerLazySingleton<FirestoreRepository>(() =>
      FirestoreRepositoryImpl(
        service: di<FirestoreService>(),
        imageCompressService: di<ImageCompressService>(),
      ));

  // GeofencingLocations
  di.registerSingletonAsync<GeofencingRepository>(() async {
    final service = await di.getAsync<GeofencingService>();
    return GeofencingRepositoryImpl(service: service);
  });

  // 사용자 위치
  di.registerSingletonAsync<UserLocationRepository>(() async {
    final service = await di.getAsync<UserLocationService>();
    return UserLocationRepositoryImpl(service);
  });

  // 로컬 데이터
  di.registerSingletonAsync<UserLocalStorageRepository>(() async {
    final service = await di.getAsync<UserLocalStorageService>();
    return UserLocalStorageRepositoryImpl(service);
  });

  // 알림
  di.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl(di<LocalNotificationService>()));

  // 권한
  di.registerLazySingleton<PermissionRepository>(() => PermissionRepositoryImpl(di<PermissionService>()));
}
