import 'package:bread_place/config/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigationBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationBar({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: navigationShell.currentIndex,
      onTap: _goBranch,
      selectedItemColor: AppColors.background,
      unselectedItemColor: AppColors.icon,
      backgroundColor: AppColors.primary,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), label: '검색'),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.pen), label: '리뷰'),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.person), label: '설정'),
      ],
    );
  }
}