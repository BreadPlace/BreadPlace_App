import 'package:bread_place/config/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/routing/routes.dart';

class MainNavigationBar extends StatelessWidget {
  const MainNavigationBar({super.key});

  static final List<String> _paths = [
    Routes.home,
    Routes.search,
    Routes.review,
    Routes.mypage,
  ];

  // Ensure the method returns a valid index even when no match is found
  int _getCurrentIndex(String location) {
    // location과 일치하는 첫 번째 경로를 찾아 인덱스를 반환
    final index = _paths.indexWhere((path) => location.startsWith(path));
    return index >= 0 ? index : 0; // Return 0 if no match is found
  }

  void _onTap(BuildContext context, int index) {
    final newLocation = _paths[index];
    final currentLocation = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();

    // 현재 위치와 새로운 위치가 다를 경우에만 이동
    if (currentLocation != newLocation) {
      context.go(newLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    final currentIndex = _getCurrentIndex(currentLocation);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.icon,
      backgroundColor: AppColors.background,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: '검색',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit_calendar),
          label: '리뷰',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '설정',
        ),
      ],
    );
  }
}