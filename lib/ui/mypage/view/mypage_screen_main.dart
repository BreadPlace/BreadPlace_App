import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:bread_place/ui/mypage/widget/mypage_menu_item.dart';

class MypageScreenMain extends StatelessWidget {
  const MypageScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: SizedBox(
          height: 800,
          child: Column(
            children: [
              _loginUserInfoView(),
              SizedBox(height: 10),

              _userMenuList(),
              SizedBox(height: 10),

              _appMenuList(),
              SizedBox(height: 10),

              _accountMenuList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginUserInfoView() {
    return _borderContainer(
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '빵플레이스 유저123',
                  style: AppTextStyles.pretendardBold.copyWith(fontSize: 18),
                ),
                SizedBox(height: 8),
                // _goReviewButton('46'),
                Text(
                  '작성한 리뷰: 46',
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

  Widget _userMenuList() {
    return _borderContainer(
      Column(
        children: [
          MypageMenuItem(
            text: '닉네임 변경',
            widget: Icon(Icons.edit, color: AppColors.sub),
          ),
          MypageMenuItem(
            text: '내가 쓴 리뷰 보기',
            widget: Icon(Icons.library_books, color: AppColors.sub),
          ),
        ],
      ),
    );
  }

  Widget _appMenuList() {
    return _borderContainer(
      Column(
        children: [
          MypageMenuItem(
            text: '약관 및 정책',
            widget: Icon(
              CupertinoIcons.chevron_right,
              color: AppColors.fontGrey,
            ),
          ),
          MypageMenuItem(
            text: '오픈소스 라이선스',
            widget: Icon(
              CupertinoIcons.chevron_right,
              color: AppColors.fontGrey,
            ),
          ),
          MypageMenuItem(
            text: '알림 설정',
            widget: Icon(CupertinoIcons.bell_fill, color: AppColors.fontGrey),
          ),
          MypageMenuItem(
            text: '앱 버전',
            widget: Text(
              'v1.0',
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

  Widget _accountMenuList() {
    return _borderContainer(
      Column(
        children: [
          MypageMenuItem(
            text: '로그아웃',
            widget: Icon(
              CupertinoIcons.square_arrow_right,
              color: AppColors.fontGrey,
            ),
          ),
          MypageMenuItem(text: '회원 탈퇴'),
        ],
      ),
    );
  }

  Widget _borderContainer(Widget child) {
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
