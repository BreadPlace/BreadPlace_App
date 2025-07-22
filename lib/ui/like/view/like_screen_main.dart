import 'package:bread_place/ui/common_widgets/common_retry_view.dart';
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
import 'package:bread_place/ui/home/bloc/home_bloc.dart';
import 'package:bread_place/ui/login/bloc/login_bloc.dart';
import 'package:bread_place/ui/login/bloc/login_state.dart';
import 'package:bread_place/ui/common_widgets/spread_butter_view.dart';

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
  void initState() {
    super.initState();
    _fetchLikedBakeries();
  }

  void _fetchLikedBakeries() {
    context.read<LikeBloc>().add(FetchLikedBakeries());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) => current is Unauthenticated,
      listener: (context, state) {
        context.read<LikeBloc>().add(ResetLikedBakeries());
      },
      child: BlocSelector<LikeBloc, LikeState, LikeState>(
        selector: (state) => state,
        builder: (context, state) {
          switch (state.status) {
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

            case LikeStatus.geofenceLimitExceeded:
              return RetryView(
                  message: state.errorMessage ?? '',
                  buttonText: '돌아가기',
                  onRetry: _fetchLikedBakeries
              );

            case LikeStatus.error:
              return RetryView(
                onRetry: _fetchLikedBakeries,
              );

            default:
              return SpreadButterView();
          }
        },
      ),
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
Widget bellButton(VoidCallback onPressed, bool isNotified) {
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

    // 알림 버튼 클릭 시 작동
    void onBellButtonPressed(Bakery bakery, bool isNotificationAllowed) async {
      context.read<LikeBloc>().add(ToggleNotification(
          bakery: bakery, isNotificationAllowed: isNotificationAllowed));
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
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              itemCount: likes.length,
              itemBuilder: (context, index) {
                final likedBakery = likes[index];
                final bakery = likedBakery.bakery;
                final notify = likedBakery.isNotificationAllowed;

                if (bakery == null) return const SizedBox.shrink(); // null 방지

                return BlocSelector<HomeBloc, HomeState, LatLng?>(
                  selector: (state) => state.userLocation,
                  builder: (context, userLocation) {
                    return LikedBakeryContainer(
                      bakery: bakery,
                      onTapContainer: () => onBakeryContainerTapped(bakery),
                      onHeartButtonPressed: () => showRemoveDialog(context, bakery),
                      onBellButtonPressed: () => onBellButtonPressed(bakery, notify),
                      isNotified: notify,
                      userLocation: userLocation,
                    );
                  }
                );
              }, separatorBuilder: (_, _) => const SizedBox(height: 4) // 여백
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
  final VoidCallback onHeartButtonPressed;
  final VoidCallback onBellButtonPressed;
  final bool isNotified;

  const LikedBakeryContainer({
    super.key,
    required this.bakery,
    this.userLocation,
    required this.onTapContainer,
    required this.onHeartButtonPressed,
    required this.onBellButtonPressed,
    required this.isNotified,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapContainer,
      child: Container(
        height: 130,
        padding: EdgeInsets.fromLTRB(20,0,6,0),
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
            heartButton(onHeartButtonPressed),
            bellButton(onBellButtonPressed, isNotified)
          ],
        ),
      ),
    );
  }
}

