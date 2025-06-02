import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/di/locator.dart';
import 'package:bread_place/config/routing/routes.dart';
import 'package:bread_place/ui/common_widgets/login_required_dialog.dart';
import 'package:bread_place/ui/login/bloc/login_bloc.dart';
import 'package:bread_place/ui/login/bloc/login_state.dart';

import 'package:go_router/go_router.dart';

class MainNavigationBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationBar({super.key, required this.navigationShell});

  void _goBranch(context, int index) {
    navigationShell.goBranch(index); // 해당 탭으로 이동 후
    _requireLoginIfProtectedTab(context, index); // 권한 체크
  }

  // 로그인하지 않은 사용자가 특정 화면 접근 시, 로그인 요구
  void _requireLoginIfProtectedTab(context, int index) {
    // 로그인 상태
    final loginState = di<LoginBloc>().state;

    // 로그인이 필요한 화면 정의
    final protectedPaths = [
      Routes.review,
    ];

    // 현재 탭이 로그인 필요한 화면인지 확인
    final currentPath = navigationShell.route.branches[index].routes;
    bool isProtectedTab = protectedPaths.any(
      (protectedPath) => currentPath.toString().contains(protectedPath),
    );

    if (loginState is Unauthenticated && isProtectedTab) {
      showDialog(
        context: context,
        barrierDismissible: false, // 외부 터치로 닫기 비허용
        builder: (_) => const LoginRequiredDialog(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _goBranch(context, index),
        selectedItemColor: AppColors.background,
        unselectedItemColor: AppColors.icon,
        backgroundColor: AppColors.primary,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), label: '검색'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.pen), label: '리뷰'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.person), label: '설정'),
        ],
      ),
    );
  }
}