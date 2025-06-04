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
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRect(
        child: CachedNetworkImage(
          fit: BoxFit.fill,
          imageUrl: uri,
          placeholder:
              (_,_) => CircularProgressIndicator(color: AppColors.primary),
          errorWidget: (_,_,_) => Icon(Icons.error),
        ),
      ),
    );
  }
}
