import 'package:flutter/material.dart';

import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';

class MypageMenuItem extends StatelessWidget {
  final String text;
  final Widget? widget;
  final VoidCallback? onTap;

  const MypageMenuItem({
    super.key,
    required this.text,
    this.widget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.grey)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: AppTextStyles.pretendardBold.copyWith(fontSize: 16),
              ),
              widget ?? SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
