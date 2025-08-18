import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/ui/common_widgets/common_left_text_view.dart';
import 'package:bread_place/ui/common_widgets/common_breadplace_title_view.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/ui/common_widgets/empty_result_view.dart';
import 'package:bread_place/ui/home/bloc/home_bloc.dart';
import 'package:bread_place/config/constants/app_locations.dart';
import 'package:bread_place/config/constants/app_constants.dart';
import 'package:bread_place/config/routing/routes.dart';
import 'package:bread_place/ui/common_widgets/common_bakery_container.dart';
import 'package:bread_place/ui/login/bloc/login_bloc.dart';
import 'package:bread_place/ui/login/bloc/login_event.dart';
import 'package:bread_place/utils/calculate_distance.dart';
import 'package:bread_place/ui/common_widgets/spread_butter_view.dart';
import 'package:bread_place/ui/like/bloc/like_bloc.dart';
import 'package:bread_place/ui/login/bloc/login_state.dart';
import 'package:bread_place/ui/permission/bloc/permission_bloc.dart';
import 'package:bread_place/ui/permission/bloc/permission_event.dart';
import 'package:bread_place/ui/common_widgets/common_dialog.dart';
import 'package:bread_place/ui/permission/bloc/permission_state.dart';
import 'package:bread_place/ui/like/bloc/like_state.dart';
import 'package:bread_place/ui/like/bloc/like_event.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreenMain extends StatefulWidget {
  const HomeScreenMain({super.key});

  @override
  State<HomeScreenMain> createState() => _HomeScreenMainState();
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  GoogleMapController? mapController;
  bool _isPermissionDialogShowing = false; // 중복 다이얼로그 방지

  @override
  void initState() {
    super.initState();
  }

  void _checkPermissionStatus() {
    context.read<PermissionBloc>().add(CheckAllPermissionStatus());
  }

  void _checkGeofenceDataIfLoggedIn() async {
    context.read<LikeBloc>().add(CheckGeofenceIfLoggedIn());
  }

  void _showPermissionRequestDialog(BuildContext context) {
    if (_isPermissionDialogShowing) return;
    _isPermissionDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CommonDialog(
        title: '권한 요청',
        content: '알림을 켜둔 빵집이 있어요!\n'
            '이 기능을 사용하려면 아래 권한을 허용해 주세요.\n\n'
            '📍 위치 (항상 허용)\n'
            '🔔 알림',
        positiveButtonText: '권한 허용',
        negativeButtonText: '취소',
        onTapPositiveButton: () {
          _ensurePermission();
          context.pop();
          _isPermissionDialogShowing = false;
        },
        onTapNegativeButton: () {
          context.pop();
          _isPermissionDialogShowing = false;
        },
      ),
    );
  }

  void _ensurePermission() {
    context.read<PermissionBloc>().add(EnsureGeofencePermission());
  }

  // 탐색 버튼이 눌렸을 때 이벤트
  void _onSearchLocationTapped() async {
    if(mapController == null) { return; }
    final bounds = await mapController!.getVisibleRegion();
    final center = getCenterLatLng(bounds);
    context.read<HomeBloc>().add(HomeSearchLocation(location: center));
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
    final state = context.read<HomeBloc>().state;
    if(state.userLocation != null) {
      _changeCameraPosition(state.userLocation!);
    }
  }

  void _onMapMoved(CameraPosition position) {
    context.read<HomeBloc>().add(HomeMapMoved(cameraPosition: position.target));
  }

  void _onMapStopped() async {
    if(mapController == null) { return; }
    final bounds = await mapController!.getVisibleRegion();
    final center = getCenterLatLng(bounds);

    context.read<HomeBloc>().add(HomeMapStopped(lastPosition: center));
  }

  // 리스트의 베이커리를 선택했을 때
  void _onSelectBakery(Bakery bakery) {
    context.push(Routes.bakeryDetail, extra: bakery);
  }

  // 추천 베이커리를 선택했을 때
  void _onSelectRecommendBakery(){
    final state = context.read<HomeBloc>().state;
    context.push(Routes.bakeryDetail, extra: state.recommendBakery);
  }

  void _changeCameraPosition(LatLng to) {
    if(mapController == null) { return; }
    mapController!.animateCamera(CameraUpdate.newLatLng(to));
  }

  @override
  Widget build(BuildContext context) {
    const String tabTitle = '빵플레이스';
    const String mapViewTitle = '현재 위치';
    const String bakeryListViewTitle = '근처 베이커리';

    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, loginState) {
            // 1. 로그인 -> 지오펜스 확인
            if (loginState is Authenticated) {
              _checkGeofenceDataIfLoggedIn();
            }
          },
        ),
        BlocListener<LikeBloc, LikeState>(
            listener: (context, likeState) {
              // 2. 지오펜스 확인 -> 권한 확인
              if (likeState.hasLocalGeofence) {
                _checkPermissionStatus();
              }
            }),

        BlocListener<PermissionBloc, PermissionState>(
          listener: (context, permissionState) {
            // 3. 권한 체크 -> 지오펜스 초기 등록
            if (permissionState.isAllGranted) {
              context.read<LikeBloc>().add(InitializeGeofence());
            } else  {
              // 권한 필요 다이얼로그
              _showPermissionRequestDialog(context);
            }
          },
        ),
      ],
        child: Column(
          children: [
            // 커스텀 타이틀
            BreadPlaceTitleView(
              title: tabTitle,
              titleImage: const AssetImage('assets/images/Croissant.png'),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 랜덤 추천 빵집
                    _RecommendBakeryView(onRecommendBakeryTapped: _onSelectRecommendBakery),
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
        ),
    );
  }
}

class _RecommendBakeryView extends StatelessWidget {
  final VoidCallback onRecommendBakeryTapped;

  const _RecommendBakeryView({
    required this.onRecommendBakeryTapped,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, (Bakery?, LatLng)>(
    selector:
    (state) =>
    state is HomeScreenState
    ? (
    state.recommendBakery,
    state.userLocation ?? AppLocations.seoulStation,
    )
        : (null, AppLocations.seoulStation),

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

              recommendBakery != null
              ? CommonBakeryContainer(
                  bakery: recommendBakery,
                  onTap: onRecommendBakeryTapped,
                  userLocation: userLocation,
              )
              : Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                )
              )
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (prev, curr) => prev.userLocation != curr.userLocation,
      listener: (context, state) {
        if (state.userLocation != null) {
          changeCameraPosition(state.userLocation!);
        }
      },
      child: BlocSelector<HomeBloc, HomeState, (List<Bakery>, LatLng?, bool, bool, LatLng?, bool)>(
        selector:
            (state) =>
                state is HomeScreenState
                    ? (
                      state.bakeryList,
                      state.userLocation,
                      state.isFarFromLastSearch,
                      state.isMapMoving,
                      state.mapCenter,
                      state.isLoadingBakery
                    )
                    : ([], AppLocations.seoulStation, true, false, null, false),
        builder: (context, data) {
          final nearbyBakeries = data.$1;
          final userLocation = data.$2;
          final isFarFromLastSearch = data.$3;
          final isMapMoving = data.$4;
          final mapCenter = data.$5;
          final isLoadingBakery = data.$6;
          final isSearchable = !isLoadingBakery && isFarFromLastSearch;

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
                    onPressed: isSearchable ? onTrailingTap : null,
                    style: TextButton.styleFrom(
                      backgroundColor:
                      isSearchable
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
                      onMapCreated: (GoogleMapController controller) {
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
                            onTap: () => onMarkerTapped(bakery.id),
                          ),
                      },
                      circles:
                          isMapMoving
                              ? {}
                              : {
                                Circle(
                                  circleId: CircleId('searchPlace'),
                                  center:
                                      mapCenter ?? AppLocations.seoulStation,
                                  radius: AppConstants.searchRadiusMeter,
                                  fillColor: Colors.blue.withOpacity(0.5),
                                  strokeColor: Colors.blue,
                                  strokeWidth: 1,
                                ),
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, (List<Bakery>, LatLng, Bakery?, bool)>(
      selector:
          (state) =>
              state is HomeScreenState
                  ? (
                    state.bakeryList,
                    state.userLocation ?? AppLocations.seoulStation,
                    state.markerTappedBakery,
                    state.isLoadingBakery,
                  )
                  : ([], AppLocations.seoulStation, null, false),

      builder: (context, data) {
        final nearbyBackeies = data.$1;
        final userLocation = data.$2;
        final markerTappedBakery = data.$3;
        final isLoadingBakery = data.$4;

        final bakeryListView = Container(
          height: 400,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: isLoadingBakery == true
              ? SpreadButterView()
              : nearbyBackeies.isEmpty
                  ? EmptyResultView(
                    headLine: '검색결과',
                    message: '근처에 있는 빵집이 빵개입니다...',
                    imageProvider: AssetImage('assets/images/baumkuhen.png'),
                  )
                  : ListView.separated(
                    itemCount: nearbyBackeies.length,
                    separatorBuilder: (context, index) => Divider(height: 1),
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
