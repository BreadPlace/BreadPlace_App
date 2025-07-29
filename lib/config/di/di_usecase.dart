import 'package:bread_place/domain/repositories/firestore_repository.dart';
import 'package:bread_place/domain/repositories/geofencing_repository.dart';
import 'package:bread_place/domain/repositories/google_login_repository.dart';
import 'package:bread_place/domain/repositories/google_place_repository.dart';
import 'package:bread_place/domain/repositories/kakao_login_repository.dart';
import 'package:bread_place/domain/repositories/notification_repository.dart';
import 'package:bread_place/domain/repositories/permission_repository.dart';
import 'package:bread_place/domain/repositories/user_local_storage_repository.dart';
import 'package:bread_place/domain/repositories/user_location_repository.dart';
import 'package:bread_place/domain/usecases/firestore_use_case.dart';
import 'package:bread_place/domain/usecases/geofencing_use_case.dart';
import 'package:bread_place/domain/usecases/liked_bakery_use_case.dart';
import 'package:bread_place/domain/usecases/login_use_case.dart';
import 'package:bread_place/domain/usecases/notification_use_case.dart';
import 'package:bread_place/domain/usecases/permission_use_case.dart';
import 'package:bread_place/domain/usecases/search_bakery_use_case.dart';
import 'package:bread_place/domain/usecases/user_local_storage_use_case.dart';
import 'package:bread_place/domain/usecases/user_location_use_case.dart';
import 'package:get_it/get_it.dart';

void registerUseCase(GetIt di) {
  // 베이커리 검색
  di.registerLazySingleton<SearchBakeryUseCase>(() => SearchBakeryUseCase(repository: di<GooglePlaceRepository>()));

  // 파이어 스토어
  di.registerLazySingleton<FirestoreUseCase>(() => FirestoreUseCase(repository: di<FirestoreRepository>()));

  // 로컬 저장
  di.registerLazySingleton<UserLocalStorageUseCase>(() => UserLocalStorageUseCase(repository: di<UserLocalStorageRepository>()));

  // 권한
  di.registerLazySingleton<PermissionUseCase>(() => PermissionUseCase(repository: di<PermissionRepository>()));

  // 알림
  di.registerLazySingleton<NotificationUseCase>(() =>
      NotificationUseCase(notificationRepository: di<NotificationRepository>(),
          permissionRepository: di<PermissionRepository>()));

  // 빵짐 - 좋아요
  di.registerLazySingleton(() =>
      LikedBakeryUseCase(
          firestoreRepo: di<FirestoreRepository>(),
          userLocalStorage: di<UserLocalStorageRepository>(),
          permissionRepo: di<PermissionRepository>()));

  // Login
  di.registerSingletonAsync<LoginUseCase>(() async {
    return LoginUseCase(
      firestoreRepository: di<FirestoreRepository>(),
      userLocalStorageRepository: await di.getAsync<UserLocalStorageRepository>(),
      kakaoLoginRepository: await di.getAsync<KakaoLoginRepository>(),
      googleLoginRepository: await di.getAsync<GoogleLoginRepository>(),
      geofencingRepository: await di.getAsync<GeofencingRepository>(),
    );
  });

  // GeofencingLocations
  di.registerSingletonAsync<GeofencingUseCase>(() async {
    final userLocalStorageRepository = await di.getAsync<UserLocalStorageRepository>();
    final geofencingRepository = await di.getAsync<GeofencingRepository>();

    final usecase = GeofencingUseCase(
        userLocalStorageRepository: userLocalStorageRepository,
        geofencingRepository: geofencingRepository,
        notificationRepository: di<NotificationRepository>()
    );

    usecase.init();
    return usecase;
  });

  // 사용자 위치
  di.registerLazySingleton<UserLocationUseCase>(() =>
      UserLocationUseCase(
        userLocationRepository: di<UserLocationRepository>(),
        permissionRepository: di<PermissionRepository>(),
      ));
}