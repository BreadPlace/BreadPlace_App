import 'package:flutter/cupertino.dart';

import 'package:bread_place/config/routing/routes.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/domain/usecases/firestore_use_case.dart';
import 'package:bread_place/domain/usecases/user_local_storage_use_case.dart';
import 'package:bread_place/ui/bakery_detail/bloc/bakery_detail_bloc.dart';
import 'package:bread_place/ui/bakery_detail/view/bakery_detail_screen.dart';
import 'package:bread_place/ui/like/view/like_screen_main.dart';
import 'package:bread_place/ui/login/view/edit_nickname_screen.dart';
import 'package:bread_place/ui/review/bloc/add_review_bloc.dart';
import 'package:bread_place/ui/review/view/add_review_screen.dart';
import 'package:bread_place/config/di/locator.dart';
import 'package:bread_place/ui/common_widgets/main_scaffold.dart';
import 'package:bread_place/ui/home/view/home_screen_main.dart';
import 'package:bread_place/ui/mypage/view/view/mypage_screen_main.dart';
import 'package:bread_place/ui/search/bloc/search_bloc.dart';
import 'package:bread_place/ui/search/search_screen_main.dart';
import 'package:bread_place/ui/login/bloc/login_bloc.dart';
import 'package:bread_place/ui/login/bloc/login_state.dart';
import 'package:bread_place/ui/login/view/login_screen_main.dart';
import 'package:bread_place/utils/stream_to_listenable.dart';
import 'package:bread_place/ui/like/bloc/like_bloc.dart';
import 'package:bread_place/domain/usecases/login_use_case.dart';
import 'package:bread_place/ui/home/view/permission_info_screen.dart';
import 'package:bread_place/ui/login/bloc/nickname_edit_bloc.dart';
import 'package:bread_place/ui/mypage/view/bloc/my_page_bloc.dart';
import 'package:bread_place/ui/mypage/view/bloc/my_review_bloc.dart';
import 'package:bread_place/ui/mypage/view/bloc/my_review_event.dart';
import 'package:bread_place/ui/mypage/view/view/my_review_screen.dart';
import 'package:bread_place/ui/mypage/view/view/oss_license_screen.dart';
import 'package:bread_place/ui/mypage/view/view/terms_of_use_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bread_place/oss_licenses.dart';

final _loginBloc = di<LoginBloc>();

GoRouter createRouter({required bool isFirstLaunch}) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final shellNavigatorHomeKey = GlobalKey<NavigatorState>(
    debugLabel: 'shellHome',
  );
  final shellNavigatorSearchKey = GlobalKey<NavigatorState>(
    debugLabel: 'shellSearch',
  );
  final shellNavigatorLikeKey = GlobalKey<NavigatorState>(
    debugLabel: 'shellLike',
  );
  final shellNavigatorMypageKey = GlobalKey<NavigatorState>(
    debugLabel: 'shellMypage',
  );

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: isFirstLaunch ? Routes.permissionInfo : Routes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // UI shell
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: Routes.home,
                pageBuilder:
                    // 애니메이션 없이 페이지 전환
                    (context, state) =>
                        NoTransitionPage(child: const HomeScreenMain()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorSearchKey,
            routes: [
              GoRoute(
                path: Routes.search,
                pageBuilder:
                    (context, state) => NoTransitionPage(
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider(create: (_) => di<SearchBloc>()),
                        ],
                        child: const SearchScreenMain(),
                      ),
                    ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorLikeKey,
            routes: [
              GoRoute(
                path: Routes.like,
                pageBuilder:
                    (context, state) => NoTransitionPage(
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider(create: (_) => di<SearchBloc>()),
                        ],
                        child: const LikeScreenMain(),
                      ),
                    ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorMypageKey,
            routes: [
              GoRoute(
                path: Routes.mypage,
                pageBuilder:
                    (context, state) => NoTransitionPage(
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider(create: (_) => di<NicknameEditBloc>()),
                          BlocProvider(create: (_) => di<MyPageBloc>()),
                        ],
                        child: const MypageScreenMain(),
                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.login,
        pageBuilder:
            (context, state) =>
                const NoTransitionPage(child: LoginScreenMain()),
      ),
      GoRoute(
        path: Routes.bakeryDetail,
        builder: (context, state) {
          final bakery = state.extra as Bakery;

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) {
                  final bloc = BakeryDetailBloc(
                    firestoreUseCase: di<FirestoreUseCase>(),
                    bakery: bakery,
                  );

                  bloc.add(OnFetchReviews());

                  return bloc;
                },
              ),
            ],
            child: const BakeryDetailScreen(),
          );
        },
      ),
      GoRoute(
        path: Routes.editNickName,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => NicknameEditBloc(loginUseCase: di<LoginUseCase>()),
            child: EditNicknameScreen(),
          );
        },
      ),
      GoRoute(
        path: Routes.addReview,
        builder: (context, state) {
          final map = state.extra as Map<String, dynamic>;
          final bakeryDetailBloc = map['bloc'] as BakeryDetailBloc;
          final bakery = map['bakery'] as Bakery;

          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: bakeryDetailBloc),
              BlocProvider(
                create:
                    (_) => AddReviewBloc(
                      firestoreUseCase: di<FirestoreUseCase>(),
                      userLocalStorageUseCase: di<UserLocalStorageUseCase>(),
                      bakery: bakery,
                    ),
              ),
            ],
            child: const AddReviewScreen(),
          );
        },
      ),

      /// 내가 쓴 리뷰 Router
      GoRoute(
        path: Routes.myReview,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => di<MyReviewBloc>()..add(FetchBakeryReview()),
            child: const MyReviewScreen(),
          );
        },
      ),

      /// 이용 약관
      GoRoute(path: Routes.termsOfUse, builder: (_, _) => TermsOfUseScreen()),

      /// 오픈소스 라이선스
      GoRoute(path: Routes.ossLicenses, builder: (_, _) => OssLicenseScreen()),
      GoRoute(
        path: Routes.ossLicenseSingle,
        builder: (context, state) {
          final package = state.extra as Package;
          return MiscOssLicenseSingle(package: package);
        },
      ),

      /// 앱 권한 안내
      GoRoute(
        path: Routes.permissionInfo,
        builder: (context, state) {
          return PermissionInfoScreen();
        },
      ),
    ],
    refreshListenable: StreamToListenable([_loginBloc.stream]),
    redirect: (context, state) => _redirect(context, state, _loginBloc),
  );
}

String? _redirect(
  BuildContext context,
  GoRouterState state,
  LoginBloc loginBloc,
) {
  final isAuthenticated = loginBloc.state is Authenticated;
  final matchedLocation = state.matchedLocation;
  final fromParam = state.uri.queryParameters['from'];

  // 이미 인증된 상태에서 로그인 페이지 접근 시 -> 홈 또는 이전 경로로 보내기
  if (isAuthenticated && matchedLocation == Routes.login) {
    return fromParam ?? Routes.home;
  }

  return null;
}