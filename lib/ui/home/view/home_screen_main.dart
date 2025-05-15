import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/domain/entities/temp_bakery_entity.dart';
import 'package:bread_place/ui/common_widgets/common_left_text_view.dart';
import 'package:bread_place/ui/common_widgets/common_breadplace_title_view.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bread_place/ui/home/bloc/home_bloc.dart';
import 'package:bread_place/ui/home/bloc/latlng_extension.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class HomeScreenMain extends StatefulWidget {
  const HomeScreenMain({super.key});

  @override
  State<HomeScreenMain> createState() => _HomeScreenMainState();
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>();
  }

  late final GoogleMapController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 커스텀 타이틀
        BreadPlaceTitleView(
          title: '빵플레이스',
          titleImage: const AssetImage('assets/images/Croissant.png'),
          trailingIcon: CupertinoIcons.bell_fill,
          onTrailingTap: ontrailingIconTapped,
        ),

        const SizedBox(height: 8),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 랜덤 추천 빵집
                const _RecommandBakeryView(),
                const SizedBox(height: 16),

                // 근처 빵집 지도
                _MapView(),
                const SizedBox(height: 16),

                // 근처 빵집 리스트
                const _BakeryListView(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void ontrailingIconTapped() {
    // context.read<HomeBloc>().add(추가예정);
  }
}

class _RecommandBakeryView extends StatelessWidget {
  const _RecommandBakeryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, (TempBakeryEntity, LatLng)>(
      selector:
          (state) =>
              state is HomeScreenState
                  ? (
                    state.recommendBakery,
                    state.userLocation ?? AppLocations.seoulStation,
                  )
                  : (TempBakeryEntity.empty, AppLocations.seoulStation),

      builder: (context, data) {
        final recommendBakery = data.$1;
        final userLocation = data.$2;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeftTextView(title: '랜덤 추천 빵집'),

              const SizedBox(height: 8),

              Container(
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
                            recommendBakery.imagePath,
                            width: 44,
                            height: 44,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendBakery.name,
                          style: AppTextStyles.pretendardBold.copyWith(fontSize: 16),
                        ),
                        Text(
                          recommendBakery.address,
                          style: AppTextStyles.pretendardSemiBold.copyWith(fontSize: 12),
                        ),
                        Text(
                          "${recommendBakery.distanceFromUser(userLocation)}KM",
                          style: AppTextStyles.pretendardSemiBold.copyWith(fontSize: 14, color: AppColors.grey),
                          ),
                      ],
                    ),

                    Spacer(),

                    Text("리뷰 >"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MapView extends StatelessWidget {
  const _MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, LatLng?>(
      selector: (state) => state is HomeScreenState ? state.userLocation : null,
      builder: (context, userLocation) {
        final cameraPosition =
            userLocation != null
                ? CameraPosition(target: userLocation, zoom: 15)
                : CameraPosition(target: AppLocations.seoulStation, zoom: 15);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeftTextView(
                title: '현재 위치',
                trailingWidget: Container(
                  width: 96,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.refresh, size: 16),
                      Text(
                        '다시 탐색',
                        style: AppTextStyles.pretendardSemiBold.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                height: 280,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GoogleMap(
                    initialCameraPosition: cameraPosition,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,

                    gestureRecognizers: {
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BakeryListView extends StatelessWidget {
  const _BakeryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, (List<TempBakeryEntity>, LatLng)>(
      selector:
          (state) =>
              state is HomeScreenState
                  ? (
                    state.nearbyBakeries,
                    state.userLocation ?? AppLocations.seoulStation,
                  )
                  : ([], AppLocations.seoulStation),

      builder: (context, data) {
        final nearbyBackeies = data.$1;
        final userLocation = data.$2;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeftTextView(title: "근처 베이커리"),

              const SizedBox(height: 8),

              Container(
                height: 400,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListView.separated(
                  itemCount: nearbyBackeies.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final bakery = nearbyBackeies[index];
                    final distance = bakery.distanceFromUser(userLocation);

                    return Container(
                      padding: EdgeInsets.all(12),
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

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bakery.name,
                                style: AppTextStyles.pretendardBold.copyWith(fontSize: 16),
                              ),
                              Text(
                                bakery.address,
                                style: AppTextStyles.pretendardSemiBold.copyWith(fontSize: 12),
                              ),
                              Text(
                                "${distance}KM",
                                style: AppTextStyles.pretendardSemiBold.copyWith(fontSize: 14, color: AppColors.grey),
                              ),
                            ],
                          ),

                          Spacer(),

                          Text("리뷰 >"),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}