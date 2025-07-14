import 'package:bread_place/config/constants/app_constants.dart';
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
import 'package:bread_place/data/services/api/google/google_place_dio_client.dart';
import 'package:bread_place/data/services/api/kakao/kakao_dio_client.dart';
import 'package:bread_place/data/services/api/kakao/kakao_local_api.dart';
import 'package:bread_place/data/services/firebase/firestore_service.dart';
import 'package:bread_place/data/services/geofencing/geofencing_service.dart';
import 'package:bread_place/data/services/image/image_compress_service.dart';
import 'package:bread_place/data/services/local/user_local_storage.dart';
import 'package:bread_place/data/services/login/google_login_service.dart';
import 'package:bread_place/data/services/login/kakao_login_service.dart';
import 'package:bread_place/data/services/notification/local_notification_service.dart';
import 'package:bread_place/data/services/userlocation/user_location_service.dart';
import 'package:bread_place/data/services/permission/permission_service.dart';
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
import 'package:bread_place/domain/usecases/firestore_use_case.dart';
import 'package:bread_place/domain/usecases/geofencing_use_case.dart';
import 'package:bread_place/domain/usecases/liked_bakery_use_case.dart';
import 'package:bread_place/domain/usecases/login_use_case.dart';
import 'package:bread_place/domain/usecases/notification_use_case.dart';
import 'package:bread_place/domain/usecases/user_local_storage_use_case.dart';
import 'package:bread_place/domain/usecases/user_location_use_case.dart';
import 'package:bread_place/ui/home/bloc/home_bloc.dart';
import 'package:bread_place/domain/usecases/search_bakery_use_case.dart';
import 'package:bread_place/ui/like/bloc/like_bloc.dart';
import 'package:bread_place/ui/login/bloc/login_bloc.dart';
import 'package:bread_place/ui/search/bloc/search_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

GetIt di = GetIt.instance;

void initLocator() {
  // Util Services
  di.registerLazySingleton<ImageCompressService>(() => ImageCompressService());

  // Kakao_local
  di.registerLazySingleton<KakaoDioClient>(() => KakaoDioClient());
  di.registerLazySingleton<KakaoLocalApi>(() => KakaoLocalApi(di<KakaoDioClient>().dio));
  di.registerLazySingleton<KakaoSearchRepository>(() => KakaoSearchRepositoryImpl(kakaoLocalApi: di<KakaoLocalApi>()));
  // di.registerFactory(() => SearchBloc(di<KakaoSearchRepository>()));

  // Google_place
  di.registerLazySingleton<GooglePlaceDioClient>(() => GooglePlaceDioClient());
  di.registerLazySingleton<GooglePlaceApi>(() => GooglePlaceApi(di<GooglePlaceDioClient>().dio));
  di.registerLazySingleton< GooglePlaceRepository>(() => GooglePlaceRepositoryImpl(googlePlaceApi: di<GooglePlaceApi>()));

  // FireStore
  di.registerLazySingleton<FirestoreService>(() => FirestoreService(FirebaseFirestore.instance));
  di.registerLazySingleton<FirestoreRepository>(() =>
      FirestoreRepositoryImpl(
        service: di<FirestoreService>(),
        imageCompressService: di<ImageCompressService>(),
      ));

  // local_notification
  di.registerLazySingleton<FlutterLocalNotificationsPlugin>(() => FlutterLocalNotificationsPlugin());
  di.registerLazySingleton<LocalNotificationService>(() => LocalNotificationService(di<FlutterLocalNotificationsPlugin>()));
  di.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl(di<LocalNotificationService>()));

  /// shared_preferences
  // service 등록
  di.registerSingletonAsync<UserLocalStorageService>(() async {
    final service = UserLocalStorageService();
    await service.init();
    return service;
  });

  // repository 등록
  di.registerSingletonAsync<UserLocalStorageRepository>(() async {
    final service = await di.getAsync<UserLocalStorageService>();
    return UserLocalStorageRepositoryImpl(service);
  });

  /// UserLocation
  // UserLocation - Service
  di.registerSingletonAsync<UserLocationService>(() async {
    final service = UserLocationService();
    return service;
  });

  // UserLocation - Repository
  di.registerSingletonAsync<UserLocationRepository>(() async {
    final service = await di.getAsync<UserLocationService>();
    return UserLocationRepositoryImpl(service);
  });

  // UserLocation - UseCase
  di.registerLazySingleton<UserLocationUseCase>(()
    => UserLocationUseCase(
        userLocationRepository: di<UserLocationRepository>(),
        permissionRepository: di<PermissionRepository>(),
    )
  );

  /// Blocs
  di.registerFactory(() => HomeBloc(
      searchBakeryUseCase: di<SearchBakeryUseCase>(),
      userLocationUseCase: di<UserLocationUseCase>(),
  ));
  di.registerFactory(() => SearchBloc(di<SearchBakeryUseCase>()));
  di.registerFactory(() => LoginBloc(
    di<FirestoreRepository>(),
    di<UserLocalStorageRepository>(),
    di<LoginUseCase>(),
    di<UserLocalStorageUseCase>(),
  ));
  di.registerFactory(() => LikeBloc(di<LikedBakeryUseCase>(), di<GeofencingUseCase>()));


  /// UseCase
  di.registerLazySingleton<SearchBakeryUseCase>(() => SearchBakeryUseCase(repository: di<GooglePlaceRepository>()));
  di.registerLazySingleton<FirestoreUseCase>(() => FirestoreUseCase(repository: di<FirestoreRepository>()));
  di.registerLazySingleton<NotificationUseCase>(() => NotificationUseCase(di<NotificationRepository>()));
  di.registerLazySingleton<UserLocalStorageUseCase>(() => UserLocalStorageUseCase(repository: di<UserLocalStorageRepository>()));
  di.registerLazySingleton(() =>
      LikedBakeryUseCase(
          firestoreRepo: di<FirestoreRepository>(),
          userLocalStorage: di<UserLocalStorageRepository>(),
          permissionRepo: di<PermissionRepository>()));


  /// Login
  // Login - loginService
  di.registerLazySingleton<KakaoLoginService>(() => KakaoLoginService());
  di.registerLazySingleton<GoogleLoginService>(() => GoogleLoginService());

  // Login - Repository
  di.registerSingletonAsync<KakaoLoginRepository>(() async {
    final kakaoLoginService =  di<KakaoLoginService>();
    return KakaoLoginRepositoryImpl(kakaoLoginService: kakaoLoginService);
  });

  di.registerSingletonAsync<GoogleLoginRepository>(() async {
    final googleLoginService = di<GoogleLoginService>();
    return GoogleLoginRepositoryImpl(googleLoginService: googleLoginService);
  });

  // Login - LoginUseCase
  di.registerSingletonAsync<LoginUseCase>(() async {
    return LoginUseCase(
      firestoreRepository: di<FirestoreRepository>(),
      userLocalStorageRepository: await di.getAsync<UserLocalStorageRepository>(),
      kakaoLoginRepository: await di.getAsync<KakaoLoginRepository>(),
      googleLoginReposiory: await di.getAsync<GoogleLoginRepository>(),
    );
  });

  /// GeofencingLocations
  di.registerSingleton<MethodChannel>(
      MethodChannel(AppConstants.geofencingChannelName),
      instanceName: AppConstants.geofencingChannelName
  );

  di.registerSingleton<EventChannel>(
      EventChannel(AppConstants.geofencingEventChannelName),
      instanceName: AppConstants.geofencingEventChannelName
  );

  // GeofencingLocations - Service
  di.registerSingletonAsync<GeofencingService>(() async {
    final service = GeofencingService(
        geofencingChannel: di<MethodChannel>(instanceName: AppConstants.geofencingChannelName),
        geofencingEventChannel: di<EventChannel>(instanceName: AppConstants.geofencingEventChannelName),
    );

    await service.init();
    return service;
  });

  // GeofencingLocations - Repository
  di.registerSingletonAsync<GeofencingRepository>(() async {
    final service = await di.getAsync<GeofencingService>();
    final repository = GeofencingRepositoryImpl(service: service);
    return repository;
  });

  // GeofencingLocations - UseCase
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

  // permission_handler
  di.registerLazySingleton<PermissionService>(() => PermissionService());
  di.registerLazySingleton<PermissionRepository>(() => PermissionRepositoryImpl(di<PermissionService>()));
}