import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/constants/app_constants.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:bread_place/ui/common_widgets/common_breadplace_title_view.dart';
import 'package:bread_place/ui/common_widgets/common_dialog.dart';
import 'package:bread_place/ui/common_widgets/common_left_text_view.dart';
import 'package:bread_place/ui/common_widgets/primary_button.dart';
import 'package:bread_place/ui/common_widgets/spread_butter_view.dart';
import 'package:bread_place/ui/review/bloc/report_review_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ReportReviewScreen extends StatefulWidget {
  const ReportReviewScreen({super.key});

  @override
  State<ReportReviewScreen> createState() => _ReportReviewScreenState();
}

class _ReportReviewScreenState extends State<ReportReviewScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String title = "";
  String content = "";

  String? _onTitleValidate(String? val) {
    if (val == null) {
      return '내용을 입력해주세요';
    }

    return null;
  }

  String? _onContentValidate(String? val) {
    if (val == null) {
      return '내용을 입력해주세요';
    }

    if (val.length < 5) {
      return '5자 이상을 입력해주세요!';
    }

    return null;
  }

  void _onTitleSaved(String? val) {
    if (val == null) {
      return;
    }

    title = val;
  }

  void _onContentSaved(String? val) {
    if (val == null) {
      return;
    }

    content = val;
  }

  void _onSavedButtonTapped() {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      formKey.currentState!.save();

      context.read<ReportReviewBloc>().add(SendReport(
          title: title,
          content: content
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = AppConstants.horizontalPadding;
    const double topPadding = 20;
    const double bottomPadding = 20;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  BreadPlaceTitleView(
                    title: '리뷰 신고',
                    leadingIcon: CupertinoIcons.chevron_left,
                    onLeadingTap: context.pop,
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          horizontalPadding,
                          topPadding,
                          horizontalPadding,
                          bottomPadding,
                      ),
                      child: BlocBuilder<ReportReviewBloc, ReportReviewState>(
                        builder: (context, state) {
                          if(state.isLoading) {
                            return SpreadButterView();
                          }

                          if(state.isReportSuccess) {
                            return _buildReportDialog(context);
                          }

                          return Column(
                            children: [
                              _ReportTitleView(
                                  onSaved: _onTitleSaved,
                                  validator: _onTitleValidate
                              ),
                              SizedBox(height: 12),

                              _ReportContentView(
                                onSaved: _onContentSaved,
                                validator: _onContentValidate,
                                defaultLine: 12,
                              ),

                              Spacer(),

                              /// 저장 버튼
                              PrimaryButton(
                                text: '신고하기',
                                horizontalPadding: 0,
                                onPressed: _onSavedButtonTapped,
                              ),
                            ],
                          );
                        }
                      ),
                    ),
                  )
                ],
              )
          ),
      ),
    );
  }
}

class _ReportTitleView extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  const _ReportTitleView({
    required this.onSaved,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LeftTextView(title: '신고 사유'),
        SizedBox(height: 4),
        _TextField(expand: false, onSaved: onSaved, validator: validator),
      ],
    );
  }
}

class _ReportContentView extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final int defaultLine;

  const _ReportContentView({
    required this.onSaved,
    required this.validator,
    required this.defaultLine,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LeftTextView(title: '신고 내용'),
        SizedBox(height: 4),
        _TextField(
            expand: true,
            onSaved: onSaved,
            validator: validator,
            multiLineCount: defaultLine
        ),
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


Widget _buildReportDialog(BuildContext context){
  return CommonDialog(
    title: '신고가 완료되었습니다.',
    content: '신고하신 내용은 검토 후 24시간 이내로 처리됩니다.\n누적 3회 이상 부적절한 내용을 작성한 유저는 리뷰를 작성할 수 없게 됩니다.',
    positiveButtonText: '완료',
    onTapPositiveButton: (){
      context.pop();
    }
  );
}