import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bread_place/ui/login/bloc/login_bloc.dart';
import 'package:bread_place/ui/login/bloc/login_event.dart';
import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:bread_place/config/routing/routes.dart';
import 'package:bread_place/ui/login/bloc/login_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreenMain extends StatefulWidget {
  const LoginScreenMain({super.key});

  @override
  State<LoginScreenMain> createState() => _LoginScreenMainState();
}

class _LoginScreenMainState extends State<LoginScreenMain> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        // 신규 유저 -> 닉네임 입력 화면으로 이동
        if (state is NicknameInputInProgress) {
          context.push(Routes.editNickName);
          // 그 외 상태 -> 홈으로 보내기
        } else {
          context.go(Routes.home);
        }
      },
      child: Material(
        child: SafeArea(
          child: Container(
            color: AppColors.background,
            child: SingleChildScrollView(
              child: SizedBox(
                height: 900,
                child: Column(
                  children: [
                    _cancelLoginButton(),
                    Flexible(child: _titleImage()),
                    Flexible(flex: 2, child: _content()),

                    SizedBox(height: 20),
                    Flexible(child: _kakaoLoginButton()),
                    Flexible(child: _googleLoginButton()),
                    _loginOptionButtonDivider(),
                    Flexible(child: _guestModeButton()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleImage() {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 30),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Image.asset('assets/images/Croissant.png'),
      ),
    );
  }

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: AppTextStyles.bmJua.copyWith(fontSize: 32, height: 1.3),
                children: [
                  TextSpan(
                    text: '언젠가 가봐야지',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  TextSpan(text: ' 하고\n'),
                  TextSpan(text: '잊고 있던'),
                  TextSpan(
                    text: ' 그 빵집,\n',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              '근처에 있을 때 알려드릴게요!',
              style: AppTextStyles.bmJua.copyWith(fontSize: 30),
            ),
          ),
          SizedBox(height: 29),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              '리뷰, 북마크, 알림까지\n로그인하고 빵플레이스를 제대로 즐겨보세요',
              textAlign: TextAlign.start,
              style: AppTextStyles.pretendardRegular.copyWith(
                fontSize: 18,
                color: AppColors.fontGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cancelLoginButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          onPressed: () {
            context.read<LoginBloc>().add(LoginCanceled());
          },
          icon: Icon(CupertinoIcons.xmark),
        ),
      ),
    );
  }

  Widget _loginOptionButtonDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Container(height: 1, color: AppColors.borderGrey)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '또는',
              style: TextStyle(color: AppColors.fontGrey, fontSize: 14),
            ),
          ),
          Expanded(child: Container(height: 1, color: AppColors.borderGrey)),
        ],
      ),
    );
  }

  Widget _kakaoLoginButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          context.read<LoginBloc>().add(LoginWithKakaoRequested());
        },
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.grey,
                blurRadius: 4,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/kakao_login_large_wide.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _googleLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      child: InkWell(
        onTap: () {
          context.read<LoginBloc>().add(LoginWithGoogleRequested());
        },
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.grey,
                blurRadius: 4,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
            child: Row(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child:
                      Image.asset(
                        'assets/images/google_logo.png',
                        fit: BoxFit.cover,
                      )
                  ),

                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Sign in with Google', style: AppTextStyles.rotoboMedium),
                    ),
                  ),

              //    const Spacer(),
                  const SizedBox(width: 24),
                ]
            ),
          ),
        ),
      ),
    );


    // return Padding(
    //   padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
    //   child: InkWell(
    //     onTap: () {
    //       context.read<LoginBloc>().add(LoginWithGoogleRequested());
    //     },
    //     child: Container(
    //       width: double.infinity,
    //       height: 54,
    //       decoration: BoxDecoration(
    //         boxShadow: [
    //           BoxShadow(
    //             color: AppColors.grey,
    //             blurRadius: 4,
    //             offset: Offset(2, 4),
    //           ),
    //         ],
    //       ),
    //       child: Image.asset(
    //         'assets/images/google_login.png',
    //         fit: BoxFit.fill,
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget _guestModeButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: () {
            context.go('/home');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            shadowColor: AppColors.grey,
            elevation: 3,
          ),
          child: Text(
            '로그인 없이 둘러보기',
            style: AppTextStyles.pretendardSemiBold.copyWith(
              color: AppColors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
