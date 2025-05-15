import 'package:bread_place/config/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'common_navigation_bar.dart';
import 'common_app_bar.dart';
import '../../config/routing/routes.dart';
import 'package:bread_place/config/constants/app_colors.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  String? _getTitle(String location) {
    if (location == Routes.home) return null;
    if (location == Routes.search) return '검색';
    if (location == Routes.review) return '리뷰';
    if (location == Routes.mypage) return '마이페이지';
    return '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.of(context);
    router.routerDelegate.addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    final router = GoRouter.of(context);
    router.routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  void _onRouteChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final location = router.routerDelegate.currentConfiguration.uri.toString();
    final title = _getTitle(location);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar:
          title == null ? null : CommonAppBar(title: title, centerTitle: true),
      body: SafeArea(child: widget.child),
      bottomNavigationBar: MainNavigationBar(),
    );
  }
}
