import 'package:bread_place/config/di/locator.dart';
import 'package:bread_place/config/routing/routes.dart';
import 'package:bread_place/ui/common_widgets/common_scaffold.dart';
import 'package:bread_place/ui/home/bloc/home_bloc.dart';
import 'package:bread_place/ui/home/view/home_screen_main.dart';
import 'package:bread_place/ui/login/login_screen_main.dart';
import 'package:bread_place/ui/mypage/mypage_screen_main.dart';
import 'package:bread_place/ui/review/review_screen_main.dart';
import 'package:bread_place/ui/search/bloc/search_bloc.dart';
import 'package:bread_place/ui/search/search_screen_main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(
  initialLocation: Routes.home,
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: Routes.home,
          builder:
              (context, state) => BlocProvider(
                create: (_) => di<HomeBloc>()..add(HomeAppInitiate()),
                child: const HomeScreenMain(),
              ),
        ),
        GoRoute(
          path: Routes.search,
          builder:
              (context, state) => BlocProvider(
                create: (_) => di<SearchBloc>(),
                child: const SearchScreenMain(),
              ),
        ),
        GoRoute(
          path: Routes.review,
          builder: (context, state) => const ReviewScreenMain(),
        ),
        GoRoute(
          path: Routes.mypage,
          builder: (context, state) => const MypageScreenMain(),
        ),
      ],
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginScreenMain(),
    ),
  ],
);
