import 'package:json_annotation/json_annotation.dart';

part 'search_document.g.dart';

@JsonSerializable()
class SearchDocument {
  final String id;

  @JsonKey(name: 'place_name')
  final String placeName; // 장소명, 업체명

  @JsonKey(name: 'category_name')
  final String categoryName;

  @JsonKey(name: 'category_group_code')
  final String categoryGroupCode;

  @JsonKey(name: 'category_group_name')
  final String categoryGroupName;

  final String phone;

  @JsonKey(name: 'address_name')
  final String addressName; // 지번 주소

  @JsonKey(name: 'road_address_name')
  final String roadAddressName; // 도로명 주소

  final String x;
  final String y;

  @JsonKey(name: 'place_url')
  final String placeUrl;

  final String distance;

  SearchDocument({
    required this.id,
    required this.placeName,
    required this.categoryName,
    required this.categoryGroupCode,
    required this.categoryGroupName,
    required this.phone,
    required this.addressName,
    required this.roadAddressName,
    required this.x,
    required this.y,
    required this.placeUrl,
    required this.distance,
  });


  factory SearchDocument.fromJson(Map<String, dynamic> json) => _$SearchDocumentFromJson(json);
  Map<String, dynamic> toJson() => _$SearchDocumentToJson(this);
}
