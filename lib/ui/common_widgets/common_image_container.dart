import 'package:flutter/material.dart';

import 'package:bread_place/config/constants/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CommonImageContainer extends StatelessWidget {
  final String uri;
  final double width;
  final double height;
  final Color boxColor;

  const CommonImageContainer({
    required this.uri,
    required this.width,
    required this.height,
    this.boxColor = AppColors.grey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isValidUri = uri.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        height: height,
        color: boxColor,
        child:
            isValidUri
                ? CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: uri,
                  placeholder:
                      (_, __) => Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                  errorWidget: (_, __, ___) => const Icon(Icons.error),
                )
                // 제공된 이미지가 없을 때
                : Image.asset('assets/images/Croissant.png'),
      ),
    );
  }
}
