import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/ui/common_widgets/common_bakery_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LikedBakeryContainer extends StatelessWidget {
  final Bakery bakery;
  final LatLng? userLocation;
  final VoidCallback onTapContainer;
  final VoidCallback onHeartPressed;
  final VoidCallback onNotificationPressed;
  final bool isNotified;

  const LikedBakeryContainer({
    super.key,
    required this.bakery,
    this.userLocation,
    required this.onTapContainer,
    required this.onHeartPressed,
    required this.onNotificationPressed,
    required this.isNotified,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapContainer,
      child: Container(
        height: 130,
        padding: EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGrey, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            // 가게 정보
            bakeryInfoText(bakery, userLocation),
            _heartButton(),
            _notificationButton()
          ],
        ),
      ),
    );
  }

  //  좋아요 버튼
  Widget _heartButton() {
    return IconButton(
      onPressed: onHeartPressed,
      icon: const Icon(CupertinoIcons.heart_fill, color: AppColors.icon),
    );
  }

  // 알람 설정 버튼
  Widget _notificationButton() {
    return IconButton(
      onPressed: onNotificationPressed,
      icon: isNotified
              ? Icon(CupertinoIcons.bell_fill, color: AppColors.icon)
              : Icon(CupertinoIcons.bell_slash, color: AppColors.icon),
    );
  }
}
