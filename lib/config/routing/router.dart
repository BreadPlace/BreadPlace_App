import 'package:flutter/cupertino.dart';
import 'package:bread_place/config/di/locator.dart';
import 'package:bread_place/ui/common_widgets/main_scaffold.dart';
import 'package:bread_place/ui/home/bloc/home_bloc.dart';
import 'package:bread_place/ui/home/view/home_screen_main.dart';
import 'package:bread_place/ui/mypage/mypage_screen_main.dart';
import 'package:bread_place/ui/review/review_screen_main.dart';
import 'package:bread_place/ui/search/bloc/search_bloc.dart';
import 'package:bread_place/ui/search/search_screen_main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellHome',
);
final _shellNavigatorSearchKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellSearch',
);
final _shellNavigatorReviewKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellReview',
);

GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
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
              path: '/home',
              pageBuilder:
                  // 애니메이션 없이 페이지 전환
                  (context, state) => NoTransitionPage(
                    child: BlocProvider(
                      create: (_) => HomeBloc()..add(const HomeAppInitiate()),
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
              path: '/search',
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
          navigatorKey: _shellNavigatorReviewKey,
          routes: [
            GoRoute(
              path: '/review',
              pageBuilder:
                  (context, state) =>
                      const NoTransitionPage(child: ReviewScreenMain()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/myPage',
              pageBuilder:
                  (context, state) =>
                      const NoTransitionPage(child: MypageScreenMain()),
            ),
          ],
        ),
      ],
    ),
  ],
);
