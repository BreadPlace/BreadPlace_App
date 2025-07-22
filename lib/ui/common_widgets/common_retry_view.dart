import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class RetryView extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback onRetry;

  const RetryView({
    super.key,
    this.message = '문제가 발생했습니다. 다시 시도해주세요.',
    this.buttonText = '다시 시도',
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 안내 문구
            Text(
              message,
              style: AppTextStyles.pretendardRegular,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // 버튼
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.primary,
                backgroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(buttonText,
                  style: AppTextStyles.pretendardRegular.copyWith(
                      fontSize: 16, color: AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }
}