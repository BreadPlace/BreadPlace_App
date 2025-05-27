import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonSearchBar extends StatefulWidget {
  final String? hintText;
  final void Function(String) onSubmitted;

  const CommonSearchBar({super.key, this.hintText, required this.onSubmitted});

  @override
  State<CommonSearchBar> createState() => _CommonSearchBarState();
}

class _CommonSearchBarState extends State<CommonSearchBar> {
  final String defaultHintText = '검색어를 입력해주세요';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SearchBar(
        leading: Icon(CupertinoIcons.search, color: AppColors.primary),
        elevation: WidgetStatePropertyAll(0),
        textStyle: WidgetStatePropertyAll<TextStyle>(TextStyle(color: AppColors.primary)),
        backgroundColor: WidgetStatePropertyAll(AppColors.white),
        overlayColor: WidgetStatePropertyAll(AppColors.sub),
        hintText: widget.hintText ?? defaultHintText,
        hintStyle: WidgetStateProperty.all(AppTextStyles.hintText),
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}
