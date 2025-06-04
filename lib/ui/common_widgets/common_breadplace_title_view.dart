import 'package:flutter/material.dart';

import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:bread_place/config/constants/app_colors.dart';

class BreadPlaceTitleView extends StatelessWidget {
  final String title;
  final ImageProvider? titleImage;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingTap;
  final IconData? leadingIcon;
  final VoidCallback? onLeadingTap;

  const BreadPlaceTitleView({
    required this.title,
    this.titleImage,
    this.trailingIcon,
    this.onTrailingTap,
    this.leadingIcon,
    this.onLeadingTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      //  child: Center(
      child: Row(
        children: [
          if (leadingIcon != null)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: onLeadingTap,
                icon: Icon(leadingIcon),
                iconSize: 28,
                color: AppColors.black,
              ),
            ),

          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: FittedBox(
                child: Row(
                  children: [
                    if (titleImage != null) ...[
                      Image(image: titleImage!, width: 44, height: 44),
                    ],

                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bmJua.copyWith(
                        fontSize: 32,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (trailingIcon != null)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: onTrailingTap,
                icon: Icon(trailingIcon),
                iconSize: 28,
                color: AppColors.black,
              ),
            ),
        ],
        //    ),
      ),
    );
  }
}
