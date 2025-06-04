import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/ui/common_widgets/common_bakery_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LikedBakeryContainer extends StatelessWidget {
  final Bakery bakery;
  final LatLng? userLocation;

  const LikedBakeryContainer({
    super.key,
    required this.bakery,
    this.userLocation,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGrey, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            // 가게 이미지를 담은 컨테이너
            bakeryImageContainer(bakery.photoUri),
            // 가게 정보
            bakeryInfoText(bakery, userLocation),
            // 버튼을 담은 컨테이너
            _buttonContainer(),
          ],
        ),
      ),
    );
  }


  Widget _buttonContainer() {
    return Flexible(
      child: Row(
        children: [
          Expanded(child: _likeButton()),
          Expanded(child: _notificationButton(false)),
        ],
      ),
    );
  }

  //  좋아요 버튼
  Widget _likeButton() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(CupertinoIcons.heart_fill, color: AppColors.icon),
    );
  }

  // 알람 설정 버튼
  Widget _notificationButton(bool allow) {
    return IconButton(
      onPressed: () {},
      icon:
          allow
              ? Icon(CupertinoIcons.bell_fill, color: AppColors.icon)
              : Icon(CupertinoIcons.bell_slash, color: AppColors.icon),
    );
  }
}
