import 'package:json_annotation/json_annotation.dart';

part 'display_name.g.dart';

@JsonSerializable()
class DisplayName {
  final String? text;
  final String? languageCode;

  DisplayName({this.text, this.languageCode});

  factory DisplayName.fromJson(Map<String, dynamic> json) => _$DisplayNameFromJson(json);
  Map<String, dynamic> toJson() => _$DisplayNameToJson(this);
}