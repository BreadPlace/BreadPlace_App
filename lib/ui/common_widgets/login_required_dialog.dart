import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:bread_place/config/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginRequiredDialog extends StatelessWidget {
  const LoginRequiredDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: AppColors.primary,
      // 제목, 내용
      title: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: '로그인', style: AppTextStyles.pretendardBold.copyWith(color: AppColors.primary, fontSize: 24)),
              TextSpan(text: ' 화면으로 \n이동 하시겠습니까?', style: AppTextStyles.pretendardBold.copyWith(color: AppColors.fontTitleBlack, fontSize: 24))
            ]
          ),
      ),
      titleTextStyle: AppTextStyles.pretendardBold.copyWith(fontSize: 24),
      contentTextStyle: AppTextStyles.pretendardRegular,
      content: Text('로그인이 필요한 기능입니다'),
      backgroundColor: AppColors.white,
      actions: [
        // 부정 버튼
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.grey),
            shape: WidgetStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          /// 다이얼로그 닫고 홈으로 이동
          onPressed: () {
            context.pop();
            context.go(Routes.home);
          },
          child: Text(
            '나중에',
            style: AppTextStyles.pretendardSemiBold.copyWith(
              color: AppColors.fontGrey,
            ),
          ),
        ),
        // 긍정 버튼
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.primary),
            foregroundColor: WidgetStatePropertyAll(AppColors.white),
            shape: WidgetStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          onPressed: () {
            /// 다이얼로그 닫고 로그인 화면으로 이동
            context.pop();
            context.go(Routes.login);
          },
          child: Text(
            '이동하기',
            style: AppTextStyles.pretendardSemiBold.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}