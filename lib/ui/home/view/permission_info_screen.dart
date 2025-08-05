import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/config/constants/app_text_styles.dart';
import 'package:bread_place/config/routing/routes.dart';
import 'package:bread_place/ui/home/bloc/home_bloc.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


class PermissionInfoScreen extends StatelessWidget {
  const PermissionInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),

              Text('빵플레이스 앱에서 사용하는\n권한을 알려드립니다.', style: AppTextStyles.pretendardBold.copyWith(fontSize: 24)),
              SizedBox(height: 40),

              Text('선택적 접근 권한', style: AppTextStyles.pretendardBold.copyWith(fontSize: 18, color: Colors.blueAccent)),
              SizedBox(height: 20),
              PermissionInfo(
                  name: '위치',
                  description: '주변 빵집 검색 시 사용',
                  icon: CupertinoIcons.location_solid
              ),

              PermissionInfo(
                  name: '알림',
                  description: '저장한 빵집에 가까이 있을 때 푸시 알림 전송',
                  icon: CupertinoIcons.bell
              ),

              PermissionInfo(
                  name: '카메라/사진',
                  description: '리뷰 작성 시 사진 촬영과 이미지 첨부 등',
                  icon: CupertinoIcons.camera
              ),
              SizedBox(height: 20),

              Divider(height: 0.5, color: AppColors.borderGrey),
              SizedBox(height: 20),

              Text('접근 권한 변경 방법', style: AppTextStyles.pretendardBold.copyWith(fontSize: 18, color: Colors.blueAccent)),
              SizedBox(height: 20),
              Text(
                '- 휴대폰 설정 > 빵플레이스 또는\n- 앱 내 마이페이지 > 알림 등 권한설정',
                style: AppTextStyles.hintText,
              ),

              SizedBox(height: 40),
              Text(
                '허용에 동의하지 않으셔도 앱 이용은 가능하나, 일부 서비스 이용에 제한이 있을 수 있습니다.',
                style: AppTextStyles.pretendardRegular.copyWith(fontSize: 14),
              ),
              SizedBox(height: 20),
              Text(
                '위치 권한 미허용 시, 기본 위치는 서울역으로 고정됩니다.',
                style: AppTextStyles.pretendardRegular.copyWith(fontSize: 14, color: Colors.blueAccent),
              ),
              SizedBox(height: 20),

              InkWell(
                onTap: () {
                  context.go(Routes.home);
                  context.read<HomeBloc>().add(RequestPermissionsOnFirstLaunch());
                },
                child: Container(
                  color: AppColors.primary,
                  width: double.maxFinite,
                  height: 56,
                  child: Center(child: Text('확인했어요', style: AppTextStyles.pretendardRegular.copyWith(fontSize: 18, color: Colors.white))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PermissionInfo extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;

  const PermissionInfo({
    super.key,
    required this.name,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: ShapeDecoration(shape: CircleBorder()
              ,color: AppColors.grey),
              child: Icon(icon, color: AppColors.fontGrey)
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.pretendardSemiBold),
                  Text(description, style: AppTextStyles.hintText)
                ],
              ),
            )
          ]),
    );
  }
}
