import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class EmptyResultView extends StatefulWidget {
  final String headLine;
  final String message;
  final ImageProvider imageProvider;
  final double? height;

  const EmptyResultView({
    super.key,
    required this.headLine,
    required this.message,
    required this.imageProvider,
    this.height,
  });

  @override
  State<EmptyResultView> createState() => _EmptyResultViewState();
}

class _EmptyResultViewState extends State<EmptyResultView> {
  @override
  Widget build(BuildContext context) {
    final double minHeight = MediaQuery.of(context).size.height * 0.3;

    return Column(
      children: [
        // 헤드라인
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: Container(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              widget.headLine,
              style: AppTextStyles.bmJua
            ),
          ),
        ),
        // 내용
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: widget.height ?? minHeight,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: widget.imageProvider),
              SizedBox(height: 30),
              Text(widget.message, style: AppTextStyles.bmJua),
            ],
          ),
        ),
      ],
    );
  }
}
