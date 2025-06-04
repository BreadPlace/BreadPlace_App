import 'package:bread_place/config/constants/app_constants.dart';
import 'package:bread_place/config/routing/routes.dart';
import 'package:bread_place/ui/common_widgets/common_bakery_container.dart';
import 'package:bread_place/utils/calculate_distance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/domain/entities/temp_bakery_entity.dart';
import 'package:bread_place/ui/common_widgets/common_left_text_view.dart';
import 'package:bread_place/ui/common_widgets/common_breadplace_title_view.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/ui/common_widgets/empty_result_view.dart';
import 'package:bread_place/ui/home/bloc/home_bloc.dart';
import 'package:bread_place/config/constants/app_locations.dart';
import 'package:bread_place/ui/common_widgets/common_bakery_content_view.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreenMain extends StatefulWidget {
  const HomeScreenMain({super.key});

  @override
  State<HomeScreenMain> createState() => _HomeScreenMainState();
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  final String tabTitle = '빵플레이스';
  final String mapViewTitle = '현재 위치';
  final String bakeryListViewTitle = '근처 베이커리';

  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 커스텀 타이틀
        BreadPlaceTitleView(
          title: tabTitle,
          titleImage: const AssetImage('assets/images/Croissant.png'),
          trailingIcon: CupertinoIcons.bell_fill,
          onTrailingTap: _onBellIconTapped,
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
                _MapView(
                  title: mapViewTitle,
                  onTrailingTap: _onSearchLocationTapped,
                  onMapCreated: _onMapCreated,
                  onMarkerTapped: _onMarkerTapped,
                  onMapTapped: _onMapTapped,
                  changeCameraPosition: _changeCameraPosition,
                  onMapMoved: _onMapMoved,
                  onMapStopped: _onMapStopped,
                ),
                const SizedBox(height: 16),

                // 근처 빵집 리스트
                _BakeryListView(
                  title: bakeryListViewTitle,
                  onSelectBakery: _onSelectBakery,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 벨 아이콘이 눌렸을 때 이벤트
  void _onBellIconTapped() {
    context.read<HomeBloc>().add(HomeBellIconTapped());
  }

  // 탐색 버튼이 눌렸을 때 이벤트
  void _onSearchLocationTapped() async {
    final bounds = await mapController.getVisibleRegion();
    final center = getCenterLatLng(bounds);
    context.read<HomeBloc>().add(
      HomeSearchLocation(location: center),
    );
  }

  // 마커가 선택되었을 때 이벤트
  void _onMarkerTapped(String bakeryID) {
    context.read<HomeBloc>().add(HomeMarkerTapped(bakeryID: bakeryID));
  }

  // 지도가 눌렸을 때 이벤트
  void _onMapTapped(LatLng? touchedLocation) {
    context.read<HomeBloc>().add(HomeMapTapped());
  }

  // 지도 컨트롤러를 상위로 넘기는 함수
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMapMoved(CameraPosition position) {
    context.read<HomeBloc>().add(HomeMapMoved(cameraPosition: position.target));
  }

  void _onMapStopped() async {
    final bounds = await mapController.getVisibleRegion();
    final center = getCenterLatLng(bounds);

    context.read<HomeBloc>().add(HomeMapStopped(lastPosition: center));
  }

  void _onSelectBakery(Bakery bakery) {
    context.push(Routes.bakeryDetail, extra: bakery);
  }

  void _changeCameraPosition(LatLng to) {
    mapController.animateCamera(
      CameraUpdate.newLatLng(to),
    );
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
                          style: AppTextStyles.pretendardBold.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          recommendBakery.address,
                          style: AppTextStyles.pretendardSemiBold.copyWith(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "${recommendBakery.distanceFromUser(userLocation)}KM",
                          style: AppTextStyles.pretendardSemiBold.copyWith(
                            fontSize: 14,
                            color: AppColors.grey,
                          ),
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
  final String title;
  final VoidCallback onTrailingTap;
  final void Function(GoogleMapController) onMapCreated;
  final void Function(String) onMarkerTapped;
  final void Function(LatLng?) onMapTapped;
  final void Function(LatLng) changeCameraPosition;
  final void Function(CameraPosition) onMapMoved;
  final VoidCallback onMapStopped;

  const _MapView({
    required this.title,
    required this.onTrailingTap,
    required this.onMapCreated,
    required this.onMarkerTapped,
    required this.onMapTapped,
    required this.changeCameraPosition,
    required this.onMapMoved,
    required this.onMapStopped,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (prev, curr) =>
      prev.userLocation != curr.userLocation,
      listener: (context, state) {
        if (state.userLocation != null){
          changeCameraPosition(state.userLocation!);
        }
      },
      child: BlocSelector<HomeBloc, HomeState, (List<Bakery>, LatLng?, bool, bool, LatLng?)>(
        selector:
            (state) =>
                state is HomeScreenState
                    ? (state.bakeryList, state.userLocation, state.isFarFromLastSearch, state.isMapMoving, state.mapCenter)
                    : ([], AppLocations.seoulStation, true, false, null),
        builder: (context, data) {
          final nearbyBakeries = data.$1;
          final userLocation = data.$2;
          final isFarFromLastSearch = data.$3;
          final isMapMoving = data.$4;
          final mapCenter = data.$5;

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
                  title: title,
                  trailingWidget: TextButton(
                    onPressed: isFarFromLastSearch
                    ? onTrailingTap
                    : null,
                    style: TextButton.styleFrom(
                      backgroundColor: isFarFromLastSearch
                          ? AppColors.white
                          : AppColors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size(96, 28),
                      padding: EdgeInsets.zero,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.refresh, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '다시 탐색',
                          style: AppTextStyles.pretendardSemiBold.copyWith(
                            fontSize: 14,
                          ),
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
                      onMapCreated: (GoogleMapController controller){
                        onMapCreated(controller);
                      },
                      onTap: onMapTapped,
                      onCameraMove: (CameraPosition position) {
                        onMapMoved(position);
                      },
                      onCameraIdle: onMapStopped,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      markers: {
                        for (final bakery in nearbyBakeries)
                          Marker(
                            markerId: MarkerId(bakery.id),
                            position: LatLng(
                              double.tryParse(
                                    bakery.location.latitude.toString() ?? '',
                                  ) ??
                                  AppLocations.seoulStation.latitude,
                              double.tryParse(
                                    bakery.location.longitude.toString() ?? '',
                                  ) ??
                                  AppLocations.seoulStation.longitude,
                            ),
                            infoWindow: InfoWindow(title: bakery.displayName),
                            onTap:() => onMarkerTapped(bakery.id),
                          ),
                      },
                      circles: isMapMoving
                          ? {}
                          : {
                        Circle(
                            circleId: CircleId('searchPlace'),
                            center: mapCenter ?? AppLocations.seoulStation,
                            radius: AppConstants.searchRadiusMeter,
                            fillColor: Colors.blue.withOpacity(0.5),
                            strokeColor: Colors.blue,
                            strokeWidth: 1
                        )
                      },

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
      ),
    );
  }
}

class _BakeryListView extends StatelessWidget {
  final String title;
  final void Function(Bakery) onSelectBakery;

  const _BakeryListView({
    required this.title,
    required this.onSelectBakery,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, (List<Bakery>, LatLng, Bakery?)>(
      selector:
          (state) =>
              state is HomeScreenState
                  ? (
                    state.bakeryList,
                    state.userLocation ?? AppLocations.seoulStation,
                    state.markerTappedBakery,
                  )
                  : ([], AppLocations.seoulStation, null),

      builder: (context, data) {
        final nearbyBackeies = data.$1;
        final userLocation = data.$2;
        final markerTappedBakery = data.$3;

        final bakeryListView = Container(
          height: 400,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child:
          nearbyBackeies.isEmpty
              ? EmptyResultView(
            headLine: '검색결과',
            message: '근처에 있는 빵집이 빵개입니다...',
            imageProvider: AssetImage(
              'assets/images/image_donut.png',
            ),
          )
              : ListView.separated(
            itemCount: nearbyBackeies.length,
            separatorBuilder:
                (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final bakery = nearbyBackeies[index];
              return CommonBakeryContainer(
                bakery: bakery,
                userLocation: userLocation,
                 onTap: () => onSelectBakery(bakery),
              );
            },
          ),
        );

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeftTextView(title: title),

              const SizedBox(height: 8),

              (markerTappedBakery == null)
              ? bakeryListView
              : CommonBakeryContainer(
                  bakery: markerTappedBakery,
                  userLocation: userLocation,
                  onTap: () => onSelectBakery(markerTappedBakery),
              ),
            ],
          ),
        );
      },
    );
  }
}