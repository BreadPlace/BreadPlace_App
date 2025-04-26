import 'package:bread_place/config/routing/router.dart';
import 'package:bread_place/config/theme/dark_theme.dart';
import 'package:bread_place/config/theme/light_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BreadPlace',
      theme: AppLightTheme.theme,
      darkTheme: AppDarkTheme.theme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
