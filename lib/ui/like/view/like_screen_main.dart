import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bread_place/config/routing/routes.dart';
import 'package:bread_place/ui/common_widgets/common_dialog.dart';
import 'package:bread_place/ui/common_widgets/empty_result_view.dart';
import 'package:bread_place/ui/like/bloc/like_bloc.dart';
import 'package:bread_place/ui/like/bloc/like_event.dart';
import 'package:bread_place/ui/like/bloc/like_state.dart';
import 'package:bread_place/ui/search/bloc/search_bloc.dart';
import 'package:bread_place/ui/search/bloc/search_event.dart';
import 'package:bread_place/ui/search/bloc/search_state.dart';
import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/ui/common_widgets/common_bakery_container.dart';
import 'package:flutter/services.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';


class LikeScreenMain extends StatefulWidget {
  const LikeScreenMain({super.key});

  @override
  State<LikeScreenMain> createState() => _LikeScreenMainState();
}

class _LikeScreenMainState extends State<LikeScreenMain> {

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LikeBloc, LikeState, LikeStatus>(
      selector: (state) => state.status,
      builder: (context, status) {
        switch (status) {
          case LikeStatus.success:
            return LikedListView(); // 성공 상태 시 빌드

          case LikeStatus.empty:
            return const Center(
              child: EmptyResultView(
                headLine: '',
                message: '좋아요 누른 빵집이 빵개입니다...',
                imageProvider: AssetImage('assets/images/image_donut.png'),
              ),
            );

          case LikeStatus.error:
            return const Center(child: Text("좋아요 정보를 불러오지 못했습니다"));

          case LikeStatus.initial:
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

//  좋아요 버튼
Widget heartButton(VoidCallback onPressed) {
  return IconButton(
    onPressed: onPressed,
    icon: const Icon(CupertinoIcons.heart_fill, color: AppColors.icon),
  );
}

// 알람 설정 버튼
Widget notificationButton(VoidCallback onPressed, bool isNotified) {
  return IconButton(
    onPressed: onPressed,
    icon: isNotified
        ? Icon(CupertinoIcons.bell_fill, color: AppColors.icon)
        : Icon(CupertinoIcons.bell_slash, color: AppColors.icon),
  );
}

// 좋아요 취소 확인 다이얼로그
Widget buildRemoveDialog(BuildContext context, Bakery bakery) {
  void onHeartButtonTapped(Bakery bakery) {
    bool notifyByDefault = false;
    context.read<LikeBloc>().add(
      RemoveLike(bakery: bakery, isNotify: notifyByDefault),
    );
  }

  return CommonDialog(
    content: '해당 빵집이 좋아요 목록에서 사라집니다. 정말 삭제하시겠습니까?',
    positiveButtonText: '확인',
    negativeButtonText: '취소',
    onTapPositiveButton: () {
      onHeartButtonTapped(bakery);
      context.pop();
    },
    onTapNegativeButton: () {
      context.pop();
    },
  );
}

/// 좋아요 컨테이너 목록을 보여주는 뷰
class LikedListView extends StatelessWidget {
  const LikedListView({super.key});

  @override
  Widget build(BuildContext context) {
    // 베이커리 클릭 시, 검색 트리거
    void onBakeryContainerTapped(Bakery bakery) {
      context.read<SearchBloc>().add(SearchPlaceById(placeId: bakery.id));
    }

    // 좋아요 취소 다이얼로그
    void showRemoveDialog(BuildContext context, Bakery bakery) {
      showDialog(
        context: context,
        builder: (_) => buildRemoveDialog(context, bakery),
      );
    }


    // 네이티브와 통신하기 위한 MethodChannel 생성
    const MethodChannel methodChannel = MethodChannel('com.bread_place.geofencing/method');
    const EventChannel eventChannel = EventChannel('com.bread_place.geofencing/event');

    // 안드로이드 네이티브로 Geofence 시작 요청을 보냄
    Future<void> setGeofencing() async {
        final regions = [
          '36.328690, 127.427554',
          '36.8065, 127.1522',
          '37.55467884, 126.9706069',
          '37.46333, 126.44000',
        ];

      try {
        print("Geo 플러터에서 setGeofencing 트리거");
        await methodChannel.invokeMethod("setGeofencing", regions);
      }
      catch (e) {
        print("Geo 플러터 setGeofencing invoke Method 에러 e $e");

      }
    }

    // 지오펜스 중단 요청
    Future<void> removeGeofencing() async {
      try {
        print("Geo 플러터에서 stopGeofencing 트리거");
        await methodChannel.invokeMethod("removeGeofencing");
      } catch (e) {
        print("Geo 플러터 stopGeofencing invoke Method 에러 e $e");
      }
    }

    void onEnterGeofencing() {
      eventChannel.receiveBroadcastStream().listen((dynamic event) {
        print("지오펜스 진입: $event");
      }, onError: (error) {
        print('지오펜스 이벤트 수신 오류: $error');
      });
    }

    /// 임시로 권한 요청
    Future<void> requestLocationPermissions() async {
      final locationStatus = await Permission.location.request();
      final fgServiceStatus = await Permission.locationAlways.request();

      if (locationStatus.isGranted && fgServiceStatus.isGranted) {
        print("위치 및 백그라운드 권한 허용됨");
      } else {
        print("권한 거부됨");
      }
    }

    /// 알림 버튼 클릑 시 작동
    void onNotifyButtonTapped() async {
      await requestLocationPermissions();
      await setGeofencing();

      await Future.delayed(Duration(seconds: 5));
      onEnterGeofencing();
    }


    final likes = context.select((LikeBloc bloc) => bloc.state.bakeries);

    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {
        // 검색 결과가 있으면 상세 페이지로 이동
        if (state is SearchSuccess && state.bakeries.isNotEmpty) {
          final bakery = state.bakeries.first;
          context.push(Routes.bakeryDetail, extra: bakery);
        } else {
          SnackBar(content: Text('빵집 정보 없음'));
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        itemCount: likes.length,
        itemBuilder: (context, index) {
          final likedBakery = likes[index];
          final bakery = likedBakery.bakery;
          final notify = likedBakery.isNotify;

          if (bakery == null) return const SizedBox.shrink(); // null 방지

          return LikedBakeryContainer(
            bakery: bakery,
            onTapContainer: () => onBakeryContainerTapped(bakery),
            onHeartPressed: () => showRemoveDialog(context, bakery),
            onNotificationPressed: () => onNotifyButtonTapped(),
            isNotified: notify,
          );
        },
      ),
    );
  }
}

/// 좋아요 베이커리 정보를 담은 컨테이너
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
            heartButton(onHeartPressed),
            notificationButton(onNotificationPressed, isNotified)
          ],
        ),
      ),
    );
  }
}

