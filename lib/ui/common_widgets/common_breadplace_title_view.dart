import 'package:flutter/material.dart';

import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:bread_place/config/constants/app_colors.dart';


class BreadPlaceTitleView extends StatelessWidget {
  final String title;
  final String? titleImageAsset;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingTap;

  const BreadPlaceTitleView({
    required this.title,
    this.titleImageAsset,
    this.trailingIcon,
    this.onTrailingTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (titleImageAsset != null) ...[
                  Image.asset(titleImageAsset!, width: 44, height: 44),
                  const SizedBox(width: 4),
                ],

                const SizedBox(width: 4),

                Text(
                  title,
                  style: AppTextStyles.bmJua.copyWith(fontSize: 32, color: AppColors.primary),
                ),
              ],
            ),

            if (trailingIcon != null)
              Positioned(
                right: 16,
                child: IconButton(
                  onPressed: onTrailingTap,
                  icon: Icon(trailingIcon),
                  iconSize: 28,
                  color: AppColors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
