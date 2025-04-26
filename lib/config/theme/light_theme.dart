import 'package:bread_place/config/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppLightTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary, // Primary Color
        brightness: Brightness.light,
      ),
      fontFamily: 'Pretendard',
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 18),
        bodyMedium: TextStyle(fontSize: 16),
      ),
    );
  }
}