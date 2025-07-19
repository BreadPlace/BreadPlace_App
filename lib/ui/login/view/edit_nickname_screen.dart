import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/ui/common_widgets/common_app_bar.dart';
import 'package:bread_place/ui/common_widgets/common_dialog.dart';
import 'package:bread_place/ui/common_widgets/primary_button.dart';
import 'package:bread_place/ui/login/bloc/login_bloc.dart';
import 'package:bread_place/ui/login/bloc/login_event.dart';
import 'package:bread_place/utils/generate_timestamp_nickname.dart';
import 'package:bread_place/ui/common_widgets/common_snack_bar.dart';
import 'package:bread_place/ui/login/bloc/login_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditNicknameScreen extends StatefulWidget {
  const EditNicknameScreen({super.key});

  @override
  State<EditNicknameScreen> createState() => _EditNicknameScreenState();
}

class _EditNicknameScreenState extends State<EditNicknameScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isInputValid = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    _removeTextControllerListener();
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      _isInputValid = _controller.text.trim().isNotEmpty;
    });
  }

  void _saveNickname() {
    _unfocusedKeyboard();

    if (_controller.text.isEmpty) {
     CommonSnackBar.showInfo(context, '1글자 이상 입력해주세요');
     return;
    }
    context.read<LoginBloc>().add(NicknameSubmitted(_controller.text));
  }

  void _showCancelDialogIfNeeded(BuildContext context) {
    _unfocusedKeyboard();

    if (_controller.text.isNotEmpty) {
      showDialog(context: context, builder: (_) => _buildCancelDialog(context));
    } else {
      _checkLoginStatusAndDispose();
    }
  }

  void _getRandomNickname() {
    _controller.text = generateTimestampNickname();
  }

  void _clearTextController() {
    _controller.clear();
    _validateInput();
  }

  void _removeTextControllerListener() {
    _controller.removeListener(_validateInput);
    _controller.clear();
  }

  void _unfocusedKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _checkLoginStatusAndDispose() {
    context.read<LoginBloc>().add(CheckAuthStatus());
    context.pop();
  }

  void _showSuccessMessage() {
    CommonSnackBar.showSuccess(context, '닉네임이 성공적으로 변경되었습니다');
    context.pop();
  }

  void _showFailureMessage() {
    CommonSnackBar.showError(context, '닉네임 변경에 실패했습니다');
  }

  Widget _buildCancelDialog(BuildContext context) {
    return CommonDialog(
      title: '닉네임이 저장되지 않았습니다',
      content: '작성한 닉네임이 사라집니다. 그래도 뒤로 가시겠습니까?',
      positiveButtonText: '나가기',
      onTapPositiveButton: () {
        context.pop();
        _checkLoginStatusAndDispose();
      },
      negativeButtonText: '계속 작성',
      onTapNegativeButton: () {
        context.pop(); // 다이얼로그 닫기
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: CommonAppBar(
            // 백버튼
            leading: InkWell(
              child: Icon(CupertinoIcons.back, color: AppColors.icon),
              onTap: () => _showCancelDialogIfNeeded(context),
            ),
            title: '닉네임 등록',
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => _unfocusedKeyboard(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is NicknameEdited) {
                    _showSuccessMessage();

                  } else if (state is NicknameEditFailure) {
                    _showFailureMessage();
                  }
                },
                child: Column(
                  children: [
                    // 텍스트 필드
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: SizedBox(child: _inputTextField()),
                    ),

                    _helperText(),
                    SizedBox(height: 20),

                    PrimaryButton(
                      text: '저장',
                      onPressed: _isInputValid ? _saveNickname : null,
                    ),

                    SizedBox(height: 10),

                    PrimaryButton(
                      text: '랜덤 닉네임 생성',
                      onPressed: () {
                        _getRandomNickname();
                      },
                      backgroundColor: AppColors.icon,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputTextField() {
    int maxLength = 25;

    return TextField(
      // 기본 밑줄 제거
      style: TextStyle(decorationThickness: 0),
      autofocus: true,
      controller: _controller,
      maxLength: maxLength,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣]'), // 영어 대소문자, 숫자, 한글만 허용
        ),
      ],
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            _clearTextController();
          },
          icon: Icon(CupertinoIcons.xmark_circle_fill),
        ),
        hintText: '사용하실 닉네임을 입력해주세요',
      ),
    );
  }

  Widget _helperText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(26, 0, 20, 30),
        child: Text.rich(
          TextSpan(
            text: '영어 대소문자, 숫자, 한글만 입력 가능'
                '\n닉네임 변경은 최소 ',
            style: AppTextStyles.pretendardRegular.copyWith(
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: '72시간 마다 1회',
                style: AppTextStyles.pretendardSemiBold.copyWith(
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
              TextSpan(
                text: ' 가능합니다',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
