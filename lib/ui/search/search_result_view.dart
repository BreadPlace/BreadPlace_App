import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/domain/entities/place.dart';
import 'package:flutter/material.dart';

class SearchResultView extends StatefulWidget {
  final double? height;
  final int itemCount;
  final List<Place> results;

  const SearchResultView({
    super.key,
    required this.itemCount,
    required this.results,
    this.height,
  });

  @override
  State<SearchResultView> createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<SearchResultView> {
  final String title = '검색결과';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 600,
      child: Column(
        children: [
          // 헤드라인
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 30,
                    color: AppColors.icon,
                    fontFamily: 'bmJua',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // 검색 내용
          Flexible(
            flex: 5,
            child: ListView.builder(
              itemCount: widget.itemCount,
              itemBuilder: (context, index) {
                final place = widget.results[index];
                return ListTile(
                  title: Text(place.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(place.roadAddress),
                      Text(place.categoryName),
                      Text(place.categoryGroupCode ?? '없음')
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
