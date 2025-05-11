import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bread_place/config/constants/app_colors.dart';

class SearchScreenMain extends StatefulWidget {
  const SearchScreenMain({super.key});

  @override
  State<SearchScreenMain> createState() => _SearchScreenMainState();
}

class _SearchScreenMainState extends State<SearchScreenMain> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 검색바
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SearchBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(CupertinoIcons.search, color: AppColors.primary),
              ),
              elevation: WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(AppColors.white),
              overlayColor: WidgetStatePropertyAll(AppColors.sub),
              hintText: '검색할 빵집을 입력해주세요',
              hintStyle: WidgetStateProperty.all(
                TextStyle(color: AppColors.grey),
              ),
              onSubmitted: (value) {
                /// 키보드 입력을 마쳤을 때 작동할 함수
              },
            ),
          ),
          // 헤드라인
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Container(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                '검색결과',
                style: TextStyle(
                    fontSize: 30,
                    color: AppColors.icon,
                    fontFamily: 'bmJua',
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          // Empty View
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: 400,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/image_donut.png'),
                  SizedBox(height: 30),
                  Text(
                    '일치하는 빵집이 빵개입니다...',
                    style: TextStyle(
                      fontFamily: 'pretendardBold',
                      fontSize: 26,
                      color: AppColors.sub,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
          )
        ],
      ),
    );
  }
}