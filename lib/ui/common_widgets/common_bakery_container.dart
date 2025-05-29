import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CommonBakeryContainer extends StatelessWidget {
  final Bakery bakery;
  final LatLng? userLocation;
  final VoidCallback? onTap;

  const CommonBakeryContainer({
    super.key,
    required this.bakery,
    this.userLocation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // 이미지를 담은 컨테이너
            Flexible(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(16),
                ),
                // 베이커리 이미지
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    width: 77,
                    height: 77,
                    fit: BoxFit.fill,
                    imageUrl: bakery.photoUri,
                    placeholder:
                        (context, url) =>
                            CircularProgressIndicator(color: AppColors.primary),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),

            SizedBox(width: 12),

            // 가게 정보
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bakery.displayName,
                    style: AppTextStyles.pretendardBold.copyWith(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    bakery.formattedAddress,
                    style: AppTextStyles.pretendardRegular.copyWith(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  userLocation != null
                      ? Text(
                        "${bakery.distanceFromUser(userLocation!)}KM",
                        style: AppTextStyles.pretendardBold.copyWith(
                          fontSize: 14,
                          color: AppColors.disabledGrey,
                        ),
                      )
                      : Text(
                        "사용자 위치 정보가 없습니다",
                        style: AppTextStyles.pretendardSemiBold.copyWith(
                          fontSize: 14,
                          color: AppColors.disabledGrey,
                        ),
                      ),
                ],
              ),
            ),

            SizedBox(width: 12),

            // 리뷰
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                    '리뷰',
                    style: AppTextStyles.pretendardSemiBold.copyWith(
                        fontSize: 14,
                    )
                ),
                Icon(
                    CupertinoIcons.forward,
                    color: AppColors.icon,
                    size: 16
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
