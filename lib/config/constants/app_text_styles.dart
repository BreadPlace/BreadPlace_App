import 'package:bread_place/config/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle bmJua = TextStyle(
    fontFamily: 'bmJua',
    fontSize: 26,
    color: AppColors.icon,
    fontWeight: FontWeight.bold,
  );

  static TextStyle pretendardBold = TextStyle(
    fontFamily: 'pretendardBold',
    fontSize: 26,
    color: AppColors.black,
    fontWeight: FontWeight.bold,
  );

  static TextStyle pretendardSemiBold = TextStyle(
    fontFamily: 'pretendardSemiBold',
    fontSize: 16,
    color: AppColors.black,
  );

  static TextStyle pretendardRegular = TextStyle(
    fontFamily: 'pretendardRegular',
    fontSize: 16,
    color: AppColors.black,
  );

  static TextStyle hintText = TextStyle(
    fontFamily: 'pretendardRegular',
    fontSize: 16,
    color: AppColors.grey
  );
}