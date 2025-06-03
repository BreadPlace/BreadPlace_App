import 'package:bread_place/ui/common_widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:bread_place/ui/common_widgets/main_navigation_bar.dart';
import 'package:bread_place/config/constants/app_colors.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNestedNavigation({Key? key, required this.navigationShell})
    : super(key: key ?? const ValueKey<String>('MainScaffold'));

  String _getAppbarTitle(int index) {
    return switch (index) {
      1 => '검색',
      2 => '저장한 빵집',
      3 => '마이페이지',
      _ => '빵플레이스'
    };
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      appBar: currentIndex == 0 ? null : CommonAppBar(title: _getAppbarTitle(currentIndex)),
      body: SafeArea(child: navigationShell),
      bottomNavigationBar: MainNavigationBar(navigationShell: navigationShell),
      backgroundColor: AppColors.background,
    );
  }
}
