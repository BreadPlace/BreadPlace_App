import 'package:bread_place/domain/usecases/firestore_use_case.dart';
import 'package:bread_place/domain/usecases/geofencing_use_case.dart';
import 'package:bread_place/domain/usecases/liked_bakery_use_case.dart';
import 'package:bread_place/domain/usecases/login_use_case.dart';
import 'package:bread_place/domain/usecases/notification_use_case.dart';
import 'package:bread_place/domain/usecases/permission_use_case.dart';
import 'package:bread_place/domain/usecases/search_bakery_use_case.dart';
import 'package:bread_place/domain/usecases/user_local_storage_use_case.dart';
import 'package:bread_place/domain/usecases/user_location_use_case.dart';
import 'package:bread_place/ui/home/bloc/home_bloc.dart';
import 'package:bread_place/ui/like/bloc/like_bloc.dart';
import 'package:bread_place/ui/login/bloc/login_bloc.dart';
import 'package:bread_place/ui/login/bloc/nickname_edit_bloc.dart';
import 'package:bread_place/ui/mypage/view/bloc/my_page_bloc.dart';
import 'package:bread_place/ui/mypage/view/bloc/my_review_bloc.dart';
import 'package:bread_place/ui/search/bloc/search_bloc.dart';
import 'package:get_it/get_it.dart';

void registerBloc(GetIt di) {
  // 홈 탭
  di.registerLazySingleton(() => HomeBloc(
    searchBakeryUseCase: di<SearchBakeryUseCase>(),
    userLocationUseCase: di<UserLocationUseCase>(),
    firestoreUseCase: di<FirestoreUseCase>(),
    permissionUseCase: di<PermissionUseCase>()
  ));

  // 검색 탭
  di.registerFactory(() => SearchBloc(di<SearchBakeryUseCase>()));

  // 로그인
  di.registerFactory(() => LoginBloc(
    di<LoginUseCase>(),
    di<UserLocalStorageUseCase>(),
  ));

  // 빵짐 - 좋아요
  di.registerFactory(() => LikeBloc(di<LikedBakeryUseCase>(), di<GeofencingUseCase>()));

  // 닉네임 변경
  di.registerFactory(() => NicknameEditBloc(loginUseCase: di<LoginUseCase>()));

  // 내가 쓴 리뷰
  di.registerFactory(() => MyReviewBloc(
    firestoreUseCase: di<FirestoreUseCase>(),
    userLocalStorageUseCase: di<UserLocalStorageUseCase>(),
  ));

  // 마이페이지
  di.registerFactory(() => MyPageBloc(notificationUseCase: di<NotificationUseCase>()));
}



