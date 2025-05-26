import 'package:bread_place/config/constants/app_locations.dart';
import 'package:bread_place/utils/calculate_distance.dart';
import 'package:flutter/material.dart';

import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';


class BakeryContentView extends StatelessWidget {
  final Bakery bakery;
  final LatLng? userLocation;

  const BakeryContentView({
    required this.bakery,
    this.userLocation, super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 이미지를 담은 컨테이너
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(16),
            ),
            // 베이커리 이미지
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/DonutCharacter.png',
                  width: 44,
                  height: 44,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bakery.displayName,
                  style: AppTextStyles.pretendardBold.copyWith(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  bakery.formattedAddress,
                  style: AppTextStyles.pretendardSemiBold.copyWith(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  '${getDistanceKM(userLocation ?? AppLocations.seoulStation,
                      LatLng(
                          bakery.location.latitude,
                          bakery.location.longitude
                      )
                  )}KM',
                  style: AppTextStyles.pretendardSemiBold.copyWith(
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),

          SizedBox(width: 16),

          Text("리뷰 >"),
        ],
      ),
    );
  }
}
