import 'package:bread_place/config/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CommonSnackBar {
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, backgroundColor: Colors.blueGrey);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, backgroundColor: AppColors.error);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, backgroundColor: AppColors.icon);
  }

  static void _show(BuildContext context, String message, {required Color backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 2),
      ),
    );
  }
}