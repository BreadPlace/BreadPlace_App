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
import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:bread_place/ui/login/bloc/nickname_edit_bloc.dart';
import 'package:bread_place/ui/login/bloc/nickname_edit_event.dart';
import 'package:bread_place/ui/login/bloc/nickname_edit_state.dart';

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
    _canChangeNickname();
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

  void _canChangeNickname() {
    final loginState = context.read<LoginBloc>().state;
    // 기존 유저
    if(loginState is Authenticated){
      context.read<NicknameEditBloc>().add(CheckNicknameChangeAvailability(uid: loginState.uid, isNewUser: false));
      // 신규 유저
    } else if (loginState is NewUserRequireNickname) {
      context.read<NicknameEditBloc>().add(CheckNicknameChangeAvailability(uid: loginState.uid, isNewUser: true));
    }
  }

  void _saveNickname() {
    _unfocusedKeyboard();

    if (_controller.text.isEmpty) {
      CommonSnackBar.showInfo(context, '1글자 이상 입력해주세요');
      return;
    }
    context.read<NicknameEditBloc>().add(SubmitNickname(nickname: _controller.text));
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

  void _showSignInMessage() {
    CommonSnackBar.showSuccess(context, '회원가입에 성공 했습니다.');
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
              child: BlocListener<NicknameEditBloc, NicknameEditState>(
                listener: (context, state) {
                  if (state is NicknameEditSuccess) {
                    _showSuccessMessage();
                    _checkLoginStatusAndDispose();
                  } else if (state is NicknameEditFailure) {
                    _showFailureMessage();
                  } else if (state is NicknameSavedAndSignedIn) {
                    _showSignInMessage();
                    _checkLoginStatusAndDispose();
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

                        BlocSelector<NicknameEditBloc, NicknameEditState, Duration?>(
                            selector: (state) {
                              if(state is NicknameChangeUnavailable) {
                                return state.remainingTime;
                              } else {
                                return null;
                              }
                            },
                          builder: (context, state) {
                            return  _showRemainingTime(state);
                          }),

                        PrimaryButton(
                          text: '저장',
                          onPressed: (_isInputValid) ? _saveNickname : null,
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
                '\n닉네임은 ',
            style: AppTextStyles.pretendardRegular.copyWith(fontSize: 14),
            children: [
              TextSpan(
                text: '가입 후 1회 자유롭게 변경',
                style: AppTextStyles.pretendardRegular.copyWith(
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
              TextSpan(text: '할 수 있습니다.\n단, '),
              TextSpan(
                text: '2회차 이후 72시간마다 1회',
                style: AppTextStyles.pretendardRegular.copyWith(
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
              TextSpan(text: ' 변경이 가능합니다.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showRemainingTime(Duration? remainingTime) {
    if(remainingTime == null) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 26.0, bottom: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '닉네임 변경 가능까지 ${remainingTime.inHours}시간 ${remainingTime.inMinutes.remainder(60)}분 남았습니다',
          style: AppTextStyles.pretendardRegular.copyWith(
            fontSize: 14,
            color: AppColors.error,
          ),
        ),
      ),
    );
  }
}
