import 'package:bread_place/config/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SpreadButterView extends StatelessWidget {
  const SpreadButterView({super.key});

  @override
  Widget build(BuildContext context) {
    final double minHeight = MediaQuery.of(context).size.height * 0.3;

    return Container(
      height: minHeight,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Lottie.asset('assets/animations/spreading_butter.json'),
    );
  }
}