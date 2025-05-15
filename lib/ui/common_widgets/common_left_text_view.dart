import 'package:flutter/material.dart';

class LeftTextView extends StatelessWidget {
  final String title;
  final Widget? trailingWidget;
  final double horizontalPadding;

  const LeftTextView({
    required this.title,
    this.trailingWidget,
    this.horizontalPadding = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          Text(title, style: TextStyle(fontFamily: 'bmJua', fontSize: 28)),

          const Spacer(),

          if (trailingWidget != null) trailingWidget!,
        ],
      ),
    );
  }
}
