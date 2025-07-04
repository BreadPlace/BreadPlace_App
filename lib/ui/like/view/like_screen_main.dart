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
import 'package:bread_place/config/constants/app_text_styles.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


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
      RemoveLike(bakery: bakery, isNotificationAllowed: notifyByDefault),
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
    final likes = context.select((LikeBloc bloc) => bloc.state.bakeries);
    final isNotifyCount = likes
        .where((likedBakery) => likedBakery.isNotificationAllowed)
        .length;

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

    /// 알림 버튼 클릑 시 작동
    void onNotifyButtonTapped() async {
      // TODO: UseCase로 20개 제한 코드를 옮겨야 합니다.
      if (isNotifyCount > 20) {
        return;
      }
    }

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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderGrey, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "알림을 등록한 빵집",
                    style: AppTextStyles.pretendardSemiBold.copyWith(fontSize: 16),
                  ),

                  Text(
                    "$isNotifyCount/20개",
                    style: AppTextStyles.pretendardBold.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              itemCount: likes.length,
              itemBuilder: (context, index) {
                final likedBakery = likes[index];
                final bakery = likedBakery.bakery;
                final notify = likedBakery.isNotificationAllowed;

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
          ),
        ],
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

