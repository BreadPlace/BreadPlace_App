import 'package:bread_place/ui/common_widgets/common_search_bar.dart';
import 'package:bread_place/ui/common_widgets/empty_result_view.dart';
import 'package:bread_place/ui/search/bloc/search_bloc.dart';
import 'package:bread_place/ui/search/bloc/search_state.dart';
import 'package:bread_place/ui/search/search_result_view.dart';
import 'package:flutter/material.dart';
import 'package:bread_place/config/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/search_event.dart';

class SearchScreenMain extends StatefulWidget {
  const SearchScreenMain({super.key});

  @override
  State<SearchScreenMain> createState() => _SearchScreenMainState();
}

class _SearchScreenMainState extends State<SearchScreenMain> {
  final String _headLine = '검색결과';
  final String _emptyViewMsg = '일치하는 빵집이 빵개입니다...';
  final String _hintText = '검색할 빵집을 입력해주세요';
  final String _errorText = '검색 중 오류가 발생했습니다.';
  final AssetImage emptyImage = AssetImage('assets/images/image_donut.png');

  void onSubmitSearchKeyword(BuildContext context, String keyword) {
    context.read<SearchBloc>().add(SearchPlace(keyword: keyword));
  }

  @override
  Widget build(BuildContext context) {
    // 빈공간 터치 시 키보드 내림
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          SizedBox(height: 10),
          // 검색바
          CommonSearchBar(
            hintText: _hintText,
            onSubmitted: (value) => onSubmitSearchKeyword(context, value),
          ),
          // 상태별 결과 처리
          Expanded(
            child: BlocSelector<SearchBloc, SearchState, SearchState>(
              selector: (state) => state,
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 32.0),
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is SearchFailure) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _errorText,
                      style: TextStyle(color: AppColors.error),
                    ),
                  );
                }

                if (state is SearchSuccess) {
                  if (state.places.isEmpty) {
                    return EmptyResultView(
                      headLine: _headLine,
                      message: _emptyViewMsg,
                      imageProvider: emptyImage,
                    );
                  }
                  return SearchResultView(
                    itemCount: state.places.length,
                    results: state.places,
                  );
                }

                // 기본 상태 (초기 상태 등)
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
