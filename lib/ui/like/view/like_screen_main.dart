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
import 'package:bread_place/ui/common_widgets/common_retry_view.dart';
import 'package:bread_place/ui/permission/bloc/permission_bloc.dart';
import 'package:bread_place/ui/permission/bloc/permission_event.dart';
import 'package:bread_place/ui/permission/bloc/permission_state.dart';
import 'package:bread_place/ui/common_widgets/geofence_permission_dialog.dart';

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
    _checkInitialPermission();
  }

  void _fetchLikedBakeries() {
    context.read<LikeBloc>().add(FetchLikedBakeries());
  }

  // LikeScreen 진입 시 최초 권한 확인
  void _checkInitialPermission() {
    context.read<PermissionBloc>().add(CheckAllPermissionStatus());
  }

  // LikeScreen 진입 시 최초 권한 다이얼로그 표시 함수
  void _showInitialPermissionDialog() {
    if (!mounted) return;
    final stateContext = context; // _LikeScreenMainState의 context
    showAppPermissionDialog(stateContext);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// 로그인 여부 체크
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) => current is Unauthenticated,
          listener: (context, state) {
            return context.read<LikeBloc>().add(ResetLikedBakeries());
          }),

        /// 화면 진입 시 초기 권한 체크
        BlocListener<PermissionBloc, PermissionState>(
          listenWhen: (previous, current) {
            return previous.checkStatus != PermissionCheckStatus.checked
                && current.checkStatus == PermissionCheckStatus.checked;
          }, listener: (context, state) {
          if (!state.isAllGranted) {
            _showInitialPermissionDialog();
          }
        }),
      ],
        /// 좋아요 상태에 따라 화면 UI 분기
        child: BlocSelector<LikeBloc, LikeState, LikeState>(
          selector: (state) => state,
          builder: (context, state) {
            switch (state.status) {
              case LikeStatus.success:
                return LikedListView(); // 좋아요 목록 불러오기 성공 상태 시 빌드

              case LikeStatus.geofenceInitSuccess:
                return LikedListView(); // 지오펜스 성공 상태 시 빌드

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
class LikedListView extends StatefulWidget {
  const LikedListView({super.key});

  @override
  State<LikedListView> createState() => _LikedListViewState();
}

class _LikedListViewState extends State<LikedListView> {

  // 좋아요 취소 다이얼로그
  void _showRemoveDialog(BuildContext context, Bakery bakery) {
    showDialog(
      context: context,
      builder: (_) => buildRemoveDialog(context, bakery),
    );
  }

  // 베이커리 클릭 시, 검색 트리거
  void _onBakeryContainerTapped(Bakery bakery) {
    context.read<SearchBloc>().add(SearchPlaceById(placeId: bakery.id));
  }

  // 벨버튼 클릭 시, 권한 재확인 트리거
  void _handleBellButtonPressed(Bakery bakery, bool isNotificationAllowed) {
    // 1. LikeBloc에 "이 빵집에 대한 알림 설정을 시작한다"는 정보 저장
    context.read<LikeBloc>().add(SelectBakery(bakery: bakery, isNotificationAllowed: isNotificationAllowed));

    // 2. PermissionBloc에 "현재 모든 권한 상태를 다시 확인해달라"고 요청
    context.read<PermissionBloc>().add(CheckAllPermissionStatus());
  }

  @override
  Widget build(BuildContext context) {
    final likes = context.select((LikeBloc bloc) => bloc.state.bakeries);
    final isNotifyCount = likes
        .where((likedBakery) => likedBakery.isNotificationAllowed)
        .length;


    return MultiBlocListener(
      listeners: [
        /// 검색 결과가 있으면 상세 페이지로 이동
        BlocListener<SearchBloc, SearchState>(
            listener: (context, state) {
              if (state is SearchSuccess && state.bakeries.isNotEmpty) {
                final bakery = state.bakeries.first;
                context.push(Routes.bakeryDetail, extra: bakery);
              } else {
                SnackBar(content: Text('빵집 정보 없음'));
              }
            }),
        /// 개별 벨 버튼 클릭 후 권한 상태 변경 시 반응
        BlocListener<PermissionBloc, PermissionState>(
          listenWhen: (previous, current) {
            // LikeBloc에 처리할 빵집 정보가 있고, PermissionBloc의 상태가 'checked'로 변경되었을 때만 반응
            final likeState = context.read<LikeBloc>().state;
            return likeState.selectedBakery != null &&
                previous.checkStatus != PermissionCheckStatus.checked &&
                current.checkStatus == PermissionCheckStatus.checked;
          },
          listener: (context, state) {
            final selectedBakery = context.read<LikeBloc>().state.selectedBakery;

            // 권한 있을 때 - 선택된 베이커리의 bell 버튼 토글
            if (selectedBakery != null && selectedBakery.bakery != null) {
              context.read<LikeBloc>().add(
                ToggleNotification(
                  bakery: selectedBakery.bakery!,
                  isNotificationAllowed: selectedBakery.isNotificationAllowed,
                ),
              );
            } else {
              // 권한 없을 때 - 권한 요청 다이얼로그 표시
              showAppPermissionDialog(context);
            }
          },
        ),
      ],
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
                      onTapContainer: () => _onBakeryContainerTapped(bakery),
                      onHeartButtonPressed: () => _showRemoveDialog(context, bakery),
                      onBellButtonPressed: () => _handleBellButtonPressed(bakery, notify),
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

