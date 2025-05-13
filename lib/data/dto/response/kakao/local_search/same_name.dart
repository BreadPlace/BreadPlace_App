import 'package:json_annotation/json_annotation.dart';

part 'same_name.g.dart';

@JsonSerializable()
class SameName {
  final List<String> region;
  final String keyword;

  @JsonKey(name: 'selected_region')
  final String selectedRegion;

  SameName({required this.region, required this.keyword, required this.selectedRegion});

  factory SameName.fromJson(Map<String, dynamic> json) => _$SameNameFromJson(json);
  Map<String, dynamic> toJson() => _$SameNameToJson(this);
}