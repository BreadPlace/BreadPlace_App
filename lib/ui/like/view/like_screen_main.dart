import 'package:bread_place/ui/common_widgets/empty_result_view.dart';
import 'package:bread_place/ui/like/bloc/like_bloc.dart';
import 'package:bread_place/ui/like/bloc/like_state.dart';
import 'package:bread_place/ui/like/widget/liked_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikeScreenMain extends StatelessWidget {
  const LikeScreenMain({super.key});

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
