import 'package:bread_place/config/constants/app_colors.dart';
import 'package:bread_place/ui/common_widgets/common_bakery_container.dart';
import 'package:flutter/material.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/ui/common_widgets/common_left_text_view.dart';

class SearchResultView extends StatefulWidget {
  final double? height;
  final int itemCount;
  final List<Bakery> results;

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
  final String _title = '검색결과';

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
              child: LeftTextView(title: _title),
            ),
          ),
          // 검색 내용
          Flexible(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemCount: widget.itemCount,
                itemBuilder: (context, index) {
                  final bakery = widget.results[index];
                  return CommonBakeryContainer(bakery: bakery);
                },
                separatorBuilder:
                    (context, int index) => Divider(color: AppColors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
