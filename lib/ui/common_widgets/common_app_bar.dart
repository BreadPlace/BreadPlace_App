import 'package:bread_place/config/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;

  const CommonAppBar({
    super.key,
    this.title,
    this.centerTitle = true,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title != null
            ? title!
            : ''
        ,
      ),
      centerTitle: centerTitle,
      backgroundColor: AppColors.primary,
      leading: leading,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}