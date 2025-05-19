import 'package:bread_place/data/dto/response/kakao/local_search/same_name.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_meta.g.dart';

@JsonSerializable()
class SearchMeta {
  @JsonKey(name: 'total_count')
  final int totalCount;

  @JsonKey(name: 'pageable_count')
  final int pageableCount; // total_count 중 노출 가능 문서 수 (최대: 45)

  @JsonKey(name: 'is_end')
  final bool isEnd; // 현재 페이지가 마지막 페이지인지 여부

  @JsonKey(name: 'same_name')
  final SameName? sameName; // 질의어의 지역 및 키워드 분석 정보

  SearchMeta({
    required this.totalCount,
    required this.pageableCount,
    required this.isEnd,
    this.sameName,
  });

  factory SearchMeta.fromJson(Map<String, dynamic> json) => _$SearchMetaFromJson(json);
  Map<String, dynamic> toJson() => _$SearchMetaToJson(this);
}
