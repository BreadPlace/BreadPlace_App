import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/constants/app_constants.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:bread_place/ui/common_widgets/common_breadplace_title_view.dart';
import 'package:bread_place/ui/common_widgets/common_left_text_view.dart';
import 'package:bread_place/ui/review/bloc/add_review_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  void _onContentSaved(String? val) {
    // if (val == null) {
    //   return;
    // }

    // content = val;
  }

  String? _onContentValidate(String? val) {
    // if (val == null) {
    //   return '내용을 입력해주세요';
    // }
    //
    // if (val.length < 5) {
    //   return '5자 이상을 입력해주세요!';
    // }

    return null;
  }

  void _onStarTapped(int rate) {
    print('전달받은 rate: $rate');
    context.read<AddReviewBloc>().add(RateStar(rate: rate));
    print('동작 ${context.read<AddReviewBloc>().state.rate}');
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey();
    const String title = '리뷰 작성';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<AddReviewBloc, AddReviewState>(
          builder: (context, state) {
            if (state is AddReviewState) {
              final bakery = state.bakery;

              return Form(
                key: formKey,
                child: Column(
                  children: [
                    /// 커스텀 타이틀
                    BreadPlaceTitleView(title: title),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalPadding,
                      ),
                      child: Column(
                        children: [
                          /// 별점 뷰
                          _StarRateView(
                            star: state.rate,
                            onStarTapped: _onStarTapped,
                          ),
                          SizedBox(height: 12),

                          /// 사진 추가 뷰
                          _AddPhotoView(),
                          SizedBox(height: 24),

                          /// 추천하는 빵 뷰
                          _RecommendBreadView(
                            onSaved: _onContentSaved,
                            validator: _onContentValidate,
                          ),
                          SizedBox(height: 24),

                          /// 리뷰 내용 뷰
                          _ReviewContentView(
                            onSaved: _onContentSaved,
                            validator: _onContentValidate,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _StarRateView extends StatelessWidget {
  final int star;
  final void Function(int) onStarTapped;

  const _StarRateView({
    required this.star,
    required this.onStarTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const String starRateTitle = '별점';

    return Column(
      children: [
        LeftTextView(title: starRateTitle),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
            5,
            (index) => GestureDetector(
              onTap: () => onStarTapped(index + 1),
              child:
                  (star - 1) >= index
                      ? Icon(Icons.star, size: 32, color: Colors.yellow)
                      : Icon(Icons.star_border, size: 32, color: Colors.yellow),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddPhotoView extends StatelessWidget {
  const _AddPhotoView({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(AppConstants.border),
        ),
        child: Column(
          children: [
            Icon(Icons.photo_camera, size: 34),

            SizedBox(height: 4),

            Text(
              '사진 추가',
              style: AppTextStyles.pretendardSemiBold.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendBreadView extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  const _RecommendBreadView({
    required this.onSaved,
    required this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LeftTextView(title: '추천하는 빵'),
        SizedBox(height: 4),
        _TextField(expand: false, onSaved: onSaved, validator: validator),
      ],
    );
  }
}

class _ReviewContentView extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  const _ReviewContentView({
    required this.onSaved,
    required this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LeftTextView(title: '리뷰 내용'),
        SizedBox(height: 4),
        _TextField(expand: true, onSaved: onSaved, validator: validator),
      ],
    );
  }
}

class _TextField extends StatelessWidget {
  final bool expand;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final int multiLineCount;

  const _TextField({
    required this.expand,
    required this.onSaved,
    required this.validator,
    this.multiLineCount = 5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: AppTextStyles.pretendardSemiBold.copyWith(fontSize: 16),

      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.border),
          borderSide: BorderSide(color: AppColors.white),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.border),
          borderSide: BorderSide(color: AppColors.primary), // 🔹 포커스 시 표시
        ),
        filled: true,
        fillColor: AppColors.white,
      ),
      onSaved: onSaved,
      validator: validator,
      expands: false,
      maxLines: expand ? multiLineCount : 1,
      minLines: expand ? multiLineCount : 1,
      cursorColor: AppColors.grey,
    );
  }
}
