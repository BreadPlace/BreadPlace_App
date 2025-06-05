import 'package:bread_place/config/routing/routes.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/ui/bakery_detail/bloc/bakery_detail_bloc.dart';
import 'package:bread_place/ui/bakery_detail/view/bakery_detail_screen.dart';
import 'package:bread_place/ui/like/view/like_screen_main.dart';
import 'package:bread_place/ui/login/view/edit_nickname_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:bread_place/config/di/locator.dart';
import 'package:bread_place/ui/common_widgets/main_scaffold.dart';
import 'package:bread_place/ui/home/bloc/home_bloc.dart';
import 'package:bread_place/ui/home/view/home_screen_main.dart';
import 'package:bread_place/ui/mypage/mypage_screen_main.dart';
import 'package:bread_place/ui/search/bloc/search_bloc.dart';
import 'package:bread_place/ui/search/search_screen_main.dart';
import 'package:bread_place/ui/login/bloc/login_bloc.dart';
import 'package:bread_place/ui/login/bloc/login_state.dart';
import 'package:bread_place/ui/login/view/login_screen_main.dart';
import 'package:bread_place/utils/stream_to_listenable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellHome',
);
final _shellNavigatorSearchKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellSearch',
);
final _shellNavigatorLikeKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellLike',
);

final _loginBloc = di<LoginBloc>();

GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // UI shell
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: Routes.home,
              pageBuilder:
                  // 애니메이션 없이 페이지 전환
                  (context, state) => NoTransitionPage(
                    child: BlocProvider(
                      create: (_) => di<HomeBloc>()..add(HomeAppInitiate()),
                      child: const HomeScreenMain(),
                    ),
                  ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSearchKey,
          routes: [
            GoRoute(
              path: Routes.search,
              pageBuilder:
                  (context, state) => NoTransitionPage(
                    child: BlocProvider(
                      create: (_) => di<SearchBloc>(),
                      child: const SearchScreenMain(),
                    ),
                  ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorLikeKey,
          routes: [
            GoRoute(
              path: Routes.like,
              pageBuilder:
                  (context, state) =>
              const NoTransitionPage(child: LikeScreenMain()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.mypage,
              pageBuilder:
                  (context, state) =>
                      const NoTransitionPage(child: MypageScreenMain()),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
        path: Routes.login,
        pageBuilder: (context, state) => const NoTransitionPage(child: LoginScreenMain())
    ),
    GoRoute(
      path: Routes.bakeryDetail,
      builder: (context, state) {
        final bakery = state.extra as Bakery;

        return BlocProvider(
          create: (_) => BakeryDetailBloc(bakery),
          child: const BakeryDetailScreen(),
        );
      },
    ),
    GoRoute(
        path: Routes.editNickName,
        builder: (context, state) {
          return EditNicknameScreen();
        }
    ),
  ],
  refreshListenable: StreamToListenable([_loginBloc.stream]),
  redirect: (context, state) => _redirect(context, state, _loginBloc)
);

String? _redirect(BuildContext context, GoRouterState state, LoginBloc loginBloc) {
  final isAuthenticated = loginBloc.state is Authenticated;
  final matchedLocation = state.matchedLocation;
  final fromParam = state.uri.queryParameters['from'];

  // 이미 인증된 상태에서 로그인 페이지 접근 시 -> 홈 또는 이전 경로로 보내기
  if (isAuthenticated && matchedLocation == Routes.login) {
    return fromParam ?? Routes.home;
  }

  return null;
}