import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:bread_place/domain/entities/bakery_review_entity.dart';
import 'package:bread_place/ui/common_widgets/common_breadplace_title_view.dart';
import 'package:bread_place/ui/common_widgets/common_image_container.dart';
import 'package:bread_place/ui/common_widgets/empty_result_view.dart';
import 'package:bread_place/ui/mypage/view/bloc/my_review_bloc.dart';
import 'package:bread_place/ui/mypage/view/bloc/my_review_event.dart';
import 'package:bread_place/ui/mypage/view/bloc/my_review_state.dart';
import 'package:bread_place/utils/iso_date_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyReviewScreen extends StatefulWidget {
  const MyReviewScreen({super.key});

  @override
  State<MyReviewScreen> createState() => _MyReviewScreenState();
}

class _MyReviewScreenState extends State<MyReviewScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _fetchBakeryReview();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchBakeryReview() {
    final bloc = context.read<MyReviewBloc>();
    final state = bloc.state;

    if (state.isLastReview || state.status == MyReviewStatus.loading) return;

    bloc.add(FetchBakeryReview());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: SafeArea(
          child: BlocBuilder<MyReviewBloc, MyReviewState>(
              builder: (context, state) {
                final reviews = state.reviews;

                return Column(
                  children: [
                    // 커스텀 타이틀
                    BreadPlaceTitleView(
                      title: '내가 쓴 리뷰',
                      leadingIcon: CupertinoIcons.chevron_left,
                      onLeadingTap: () => context.pop(),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            SizedBox(height: 24),

                            // 리뷰 리스트 뷰
                            _ReviewListView(reviews: reviews),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 28),
                  ],
                );
              }
          ),
        ),
      ),
    );
  }
}

class _ReviewListView extends StatelessWidget {
  final List<BakeryReviewEntity> reviews;

  const _ReviewListView({
    required this.reviews,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 16;

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          children: [
            reviews.isNotEmpty
                ? Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Column(
                  children: List.generate(
                    reviews.length,
                        (index) =>
                        Column(
                          children: [
                            _ReviewContentView(review: reviews[index],
                                horizontalPadding: horizontalPadding),
                            const Divider(height: 1),
                          ],
                        ),
                  )
              ),
            )
                : Center(
              child: EmptyResultView(
                  headLine: '',
                  message: '작성한 리뷰가 빵개입니다...',
                  imageProvider: AssetImage('assets/images/bagel.png')
              ),
            )
          ],
        )
    );
  }
}

class _ReviewContentView extends StatelessWidget {
  final BakeryReviewEntity review;
  final double horizontalPadding;

  const _ReviewContentView({
    required this.review,
    required this.horizontalPadding,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: horizontalPadding,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                    review.bakeryName,
                    style: AppTextStyles.pretendardBold.copyWith(
                      fontSize: 20,
                      color: AppColors.black,
                    )),

                SizedBox(width: 10),

                Text(
                    review.createdAt.isoStringToShortFormat(),
                    style: AppTextStyles.pretendardBold.copyWith(
                      fontSize: 16,
                      color: AppColors.fontGrey,
                    )),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  constraints: BoxConstraints(
                      minWidth: screenWidth - (horizontalPadding * 4)),
                  child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CommonImageContainer(
                                uri: review.imageUrl ?? '',
                                width: 160,
                                height: 160)),
                      ]
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(review.reviewContent,
                  style: AppTextStyles.pretendardSemiBold.copyWith(
                      fontSize: 16,
                      color: AppColors.black
                  )),
            ),
          ],
        ),
      ),
    );
  }
}