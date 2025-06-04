import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/ui/bakery_detail/bloc/bakery_detail_bloc.dart';
import 'package:bread_place/ui/common_widgets/common_breadplace_title_view.dart';
import 'package:bread_place/ui/common_widgets/common_image_container.dart';
import 'package:bread_place/ui/common_widgets/common_left_text_view.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BakeryDetailScreen extends StatefulWidget {
  const BakeryDetailScreen({super.key});

  @override
  State<BakeryDetailScreen> createState() => _BakeryDetailScreenState();
}

class _BakeryDetailScreenState extends State<BakeryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: BlocBuilder<BakeryDetailBloc, BakeryDetailState>(
          builder: (context, state) {
            if (state is BakeryDetailInitial) {
              final bakery = state.bakery;

              return Column(
                children: [
                  // 커스텀 타이틀
                  BreadPlaceTitleView(
                    title: bakery.displayName,
                    trailingIcon: CupertinoIcons.heart,
                    onTrailingTap: _onHeartButtonTapped,
                    leadingIcon: CupertinoIcons.chevron_left,
                    onLeadingTap: _onDismissButtonTapped,
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 24),

                          // 베이커리 상세 뷰
                          _BakeryDetailContentView(bakery: bakery),
                          SizedBox(height: 24),

                          // 리뷰 리스트 뷰
                          _ReviewListView(),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 28),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  void _onHeartButtonTapped() {}

  void _onDismissButtonTapped() {
    context.pop();
  }
}

class _BakeryDetailContentView extends StatelessWidget {
  final Bakery bakery;

  const _BakeryDetailContentView({required this.bakery, super.key});

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = 16;
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = screenWidth - (horizontalPadding * 2);
    final imageHeight = imageWidth * 2 / 3;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 베이커리 이미지
          CommonImageContainer(
              uri: bakery.photoUri,
              width: imageWidth,
              height: imageHeight
          ),

          SizedBox(height: 20),

          // 베이커리 정보 표시
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconTextView(text: bakery.displayName, icon: Icons.restaurant),
              SizedBox(height: 12),

              bakery.formattedPhoneNumber == ''
                  ? _IconTextView(
                text: '번호 없음',
                textColor: AppColors.grey,
                icon: CupertinoIcons.device_phone_portrait,
              )
                  : _IconTextView(
                text: bakery.formattedPhoneNumber,
                icon: CupertinoIcons.device_phone_portrait,
              ),
              SizedBox(height: 12),

              _IconTextView(text: bakery.formattedAddress, icon: CupertinoIcons.map),
              SizedBox(height: 12),

              _IconTextView(text: bakery.googleMapsUri, icon: CupertinoIcons.globe),
              SizedBox(height: 12),
            ],
          ),

          Divider(height: 2, color: AppColors.grey),
        ],
      ),
    );
  }
}

class _IconTextView extends StatelessWidget {
  final String text;
  final Color textColor;
  final IconData icon;

  const _IconTextView({
    required this.text,
    this.textColor = AppColors.black,
    required this.icon,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: AppColors.primary),

        SizedBox(width: 12),

        Expanded(
          child: Text(
            text,
            style: AppTextStyles.pretendardBold.copyWith(
                fontSize: 18,
                color: textColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        SizedBox(width: 24),
      ],
    );
  }
}

class _ReviewListView extends StatelessWidget {
  const _ReviewListView({super.key});

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = 16;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          children: [
            LeftTextView(title: '리뷰'),
            SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: List.generate(
                    3,
                    (index) => Column(
                      children: [
                        _ReviewContentView(horizontalPadding: horizontalPadding),
                        // if (index < reviewList.length - 1)
                          const Divider(height: 1),
                      ],
                    ),
                )
              ),
            ),
          ],
        )
    );
  }
}

class _ReviewContentView extends StatelessWidget {
  final double horizontalPadding;

  const _ReviewContentView({
    required this.horizontalPadding,
    super.key
  });

  @override
  Widget build(BuildContext context) {
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
              children: [
                Text(
                  '닉네임', style: AppTextStyles.pretendardBold.copyWith(
                  fontSize: 20,
                  color: AppColors.black,
                )),

                Text(
                    '25.06.05', style: AppTextStyles.pretendardBold.copyWith(
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
                  constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - (horizontalPadding * 4)),
                  child: Row(
                    children: List.generate(
                        3,
                        (index) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                          child: CommonImageContainer(
                              uri: '',
                              width: 160,
                              height: 160
                          )
                        )
                    ),
                  ),
                ),
              ),
            ),

            Text('사장님 국내산 밀가루만 쓰셔요 맛잘알 최고~~~ 승미짱~~~!!! 긴 글자 테스트까지 아아아댈매ㅔㄴ러;매ㅑ러ㅐ미ㅑㅓ리ㅐㅁ러ㅐㅑㄹ',
            style: AppTextStyles.pretendardSemiBold.copyWith(
              fontSize: 16,
              color: AppColors.black
            )),
          ],
        ),
      ),
    );
  }
}

