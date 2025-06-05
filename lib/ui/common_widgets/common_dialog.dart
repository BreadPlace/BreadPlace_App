import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommonDialog extends StatefulWidget {
  final String? title;
  final String? content;

  // 긍정 버튼 설정
  final String? positiveButtonText;
  final Color positiveButtonTextColor;
  final VoidCallback onTapPositiveButton;

  // 부정 버튼 설정
  final String? negativeButtonText;
  final Color negativeButtonTextColor;
  final VoidCallback? onTapNegativeButton;

  const CommonDialog({
    super.key,
    this.title,
    this.content,
    this.positiveButtonText,
    this.negativeButtonText,
    required this.onTapPositiveButton,
    this.onTapNegativeButton,
    this.positiveButtonTextColor = AppColors.fontMainBlack,
    this.negativeButtonTextColor = AppColors.fontMainBlack,
  });

  @override
  State<CommonDialog> createState() => _CommonDialogState();
}

class _CommonDialogState extends State<CommonDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title == null ? SizedBox.shrink() : Text('${widget.title}'),
      content:
          widget.content == null
              ? SizedBox.shrink()
              : Text('${widget.content}'),
      actions: [
        // 부정 버튼
        // negativeButtonText 또는 onTapNegativeButton 를 전달 받을 때만 생성
        if (widget.negativeButtonText != null ||
            widget.onTapNegativeButton != null)
          TextButton(
            onPressed: widget.onTapNegativeButton ?? () => context.pop(),
            style: ButtonStyle(
              overlayColor: WidgetStatePropertyAll(AppColors.primary),
            ),
            child: Text(
              widget.negativeButtonText ?? '취소',
              style: AppTextStyles.pretendardSemiBold.copyWith(
                color: widget.negativeButtonTextColor,
              ),
            ),
          ),
        // 긍정 버튼
        TextButton(
          onPressed: widget.onTapPositiveButton,
          style: ButtonStyle(
            overlayColor: WidgetStatePropertyAll(AppColors.primary),
          ),
          child: Text(
            widget.positiveButtonText ?? '확인',
            style: AppTextStyles.pretendardSemiBold.copyWith(
              color: widget.positiveButtonTextColor,
            ),
          ),
        ),
      ],
      backgroundColor: AppColors.white,
      titleTextStyle: AppTextStyles.pretendardSemiBold.copyWith(fontSize: 24),
      contentTextStyle: AppTextStyles.pretendardRegular.copyWith(fontSize: 18),
    );
  }
}
