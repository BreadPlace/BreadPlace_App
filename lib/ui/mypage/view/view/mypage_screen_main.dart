import 'package:bread_place/ui/mypage/view/bloc/my_page_bloc.dart';
import 'package:bread_place/ui/mypage/view/bloc/my_page_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:bread_place/config/routing/routes.dart';
import 'package:bread_place/ui/login/bloc/login_bloc.dart';
import 'package:bread_place/ui/login/bloc/login_state.dart';
import 'package:bread_place/ui/login/bloc/login_event.dart';
import 'package:bread_place/config/di/locator.dart';
import 'package:bread_place/domain/usecases/notification_use_case.dart';
import 'package:bread_place/ui/common_widgets/common_dialog.dart';
import 'package:bread_place/utils/iso_date_extensions.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MypageScreenMain extends StatelessWidget {
  const MypageScreenMain({super.key});
  
  void _showWithdarwDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (_) => _buildWithdrawDialog(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: SizedBox(
          height: 800,
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return _loginUserView(context, state);
              } else if (state is Unauthenticated) {
                return _guestUserView(context);
              } else {
                return _loadingView();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWithdrawDialog(BuildContext context){
    return CommonDialog(
        content: '회원 정보와 리뷰가 삭제됩니다. 정말 탈퇴하시겠습니까?',
        positiveButtonText: '탈퇴',
        negativeButtonText: '취소',
        onTapPositiveButton: (){
          context.read<LoginBloc>().add(WithDraw());
          context.pop();
        },
      onTapNegativeButton: (){
          context.pop();
      },
    );
  }

  Widget _loadingView() {
    return Center(
      child: SizedBox(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loginUserView(BuildContext context, Authenticated state) {
    return Column(
      children: [
        _loginUserInfoContainer(
          name: state.nickname ?? '저장된 닉네임이 없습니다',
          createdAt: state.createdAt.isoStringToShortFormat(),
        ),
        SizedBox(height: 10),

        UserMenuList(),
        SizedBox(height: 10),

        AppMenuList(),
        SizedBox(height: 10),

        AccountMenuList(
          onWithdrawButtonTapped: () => _showWithdarwDialog(context),
        ),
      ],
    );
  }

  Widget _guestUserView(BuildContext context) {
    return Column(
      children: [
        _loginRequiredInfoView(context),
        SizedBox(height: 10),
        AppMenuList(),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _loginRequiredInfoView(BuildContext context) {
    return BorderContainer(
        child: InkWell(
          onTap: () {
            context.go(Routes.login);
          },
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              '로그인 하러 가기',
              style: AppTextStyles.bmJua.copyWith(fontSize: 24),
              textAlign: TextAlign.center,),
          ),
        )
    );
  }

  Widget _loginUserInfoContainer({
    required String name,
    required String createdAt,
  }) {
    return BorderContainer(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.pretendardBold.copyWith(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  '가입일: $createdAt',
                  style: AppTextStyles.pretendardRegular.copyWith(
                    color: AppColors.fontGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppMenuList extends StatefulWidget {
  const AppMenuList({super.key});

  @override
  State<AppMenuList> createState() => _AppMenuListState();
}

class _AppMenuListState extends State<AppMenuList> {
  String? _appVersion;

  @override
  void initState() {
    super.initState();
    getAppVersionInfo();
  }

  void goTermsOfUseScreen() {
    context.push(Routes.termsOfUse);
  }

  void goOssLicensesPage() {
    context.push(Routes.ossLicenses);
  }

  void openDeviceAppSettings() {
    context.read<MyPageBloc>().add(OpenDeviceSetting());
  }

  Future<void> getAppVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAppVersionInfo(),
      builder: (context, snapShot) {
        return BorderContainer(
          child: Column(
            children: [
              MypageMenuItem(
                text: '약관 및 정책',
                widget: Icon(
                  CupertinoIcons.chevron_right,
                  color: AppColors.fontGrey,
                ),
                onTap: goTermsOfUseScreen,
              ),
              MypageMenuItem(
                onTap: goOssLicensesPage,
                text: '오픈소스 라이선스',
                widget: Icon(
                  CupertinoIcons.chevron_right,
                  color: AppColors.fontGrey,
                ),
              ),
              MypageMenuItem(
                onTap: openDeviceAppSettings,
                text: '알림 등 권한설정',
                widget: Icon(CupertinoIcons.settings, color: AppColors.fontGrey),
              ),
              MypageMenuItem(
                text: '앱 버전',
                widget: Text(
                  _appVersion != null ? 'v$_appVersion' : '버전 확인 중...',
                  style: AppTextStyles.pretendardRegular.copyWith(
                    color: AppColors.fontGrey,
                  ),
                ),
              ),
              MypageMenuItem(
                text: '문의 메일',
                widget: Text(
                  'opendoor2026@gmail.com',
                  style: AppTextStyles.pretendardRegular.copyWith(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class AccountMenuList extends StatelessWidget {
  final VoidCallback onWithdrawButtonTapped;

  const AccountMenuList({
    required this.onWithdrawButtonTapped,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      child: Column(
        children: [
          MypageMenuItem(
            onTap: () {
              context.read<LoginBloc>().add(LoggedOut());
            },
            text: '로그아웃',
            widget: Icon(
              CupertinoIcons.square_arrow_right,
              color: AppColors.fontGrey,
            ),
          ),
          MypageMenuItem(
            onTap: onWithdrawButtonTapped,
            text: '회원 탈퇴',
            widget: Icon(
              CupertinoIcons.exclamationmark_circle,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}


class BorderContainer extends StatelessWidget {
  final Widget child;

  const BorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: AppColors.grey, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}

class MypageMenuItem extends StatelessWidget {
  final String text;
  final Widget? widget;
  final VoidCallback? onTap;

  const MypageMenuItem({
    super.key,
    required this.text,
    this.widget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.grey)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: AppTextStyles.pretendardBold.copyWith(fontSize: 16),
              ),
              widget ?? SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class UserMenuList extends StatelessWidget {
  const UserMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    void onNicknameEditTap() {
      final state = context.read<LoginBloc>().state;

      if (state is Authenticated) {
        context.push(Routes.editNickName);
      }
    }

    void onMyReviewTap() {
      final state = context.read<LoginBloc>().state;

      if (state is Authenticated) {
        context.push(Routes.myReview);
      }
    }

    return BorderContainer(
      child: Column(
        children: [
          MypageMenuItem(
            onTap: onNicknameEditTap,
            text: '닉네임 변경',
            widget: Icon(Icons.edit, color: AppColors.sub),
          ),
          MypageMenuItem(
            onTap: onMyReviewTap,
            text: '내가 쓴 리뷰 보기',
            widget: Icon(Icons.library_books, color: AppColors.sub),
          ),
        ],
      ),
    );
  }
}

