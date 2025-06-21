import 'package:flutter/material.dart';

import 'package:bread_place/config/routing/routes.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/ui/like/bloc/like_bloc.dart';
import 'package:bread_place/ui/like/widget/liked_bakery_container.dart';
import 'package:bread_place/ui/like/bloc/like_event.dart';
import 'package:bread_place/ui/common_widgets/common_dialog.dart';
import 'package:bread_place/ui/search/bloc/search_bloc.dart';
import 'package:bread_place/ui/search/bloc/search_event.dart';
import 'package:bread_place/ui/search/bloc/search_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LikedListView extends StatefulWidget {
  const LikedListView({super.key});

  @override
  State<LikedListView> createState() => _LikedListViewState();
}

class _LikedListViewState extends State<LikedListView> {
  final isNotified = false;

  // 베이커리 클릭 시, 검색 트리거
  void _onBakeryContainerTapped(Bakery bakery) {
    context.read<SearchBloc>().add(SearchPlaceById(placeId: bakery.id));
  }

  void _onHeartButtonTapped(Bakery bakery) {
    bool notifyByDefault = false;
    context.read<LikeBloc>().add(
      RemoveLike(bakery: bakery, isNotify: notifyByDefault),
    );
  }

  void _onNotifyButtonTapped() {}

  void _showRemoveDialog(BuildContext context, Bakery bakery) {
    showDialog(
      context: context,
      builder: (_) => _buildRemoveDialog(context, bakery),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            onTapContainer: () => _onBakeryContainerTapped(bakery),
            onHeartPressed: () => _showRemoveDialog(context, bakery),
            onNotificationPressed: () => _onNotifyButtonTapped(),
            isNotified: notify,
          );
        },
      ),
    );
  }

  // 좋아요 취소 확인 다이얼로그
  Widget _buildRemoveDialog(BuildContext context, Bakery bakery) {
    return CommonDialog(
      content: '해당 빵집이 좋아요 목록에서 사라집니다. 정말 삭제하시겠습니까?',
      positiveButtonText: '확인',
      negativeButtonText: '취소',
      onTapPositiveButton: () {
        _onHeartButtonTapped(bakery);
        context.pop();
      },
      onTapNegativeButton: () {
        context.pop();
      },
    );
  }
}
