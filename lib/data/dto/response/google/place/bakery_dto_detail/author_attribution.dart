import 'package:json_annotation/json_annotation.dart';

part 'author_attribution.g.dart';

@JsonSerializable()
class AuthorAttribution {
  final String? displayName;
  final String? uri;
  final String? photoUri;

  AuthorAttribution(this.displayName, this.uri, this.photoUri);

  factory AuthorAttribution.fromJson(Map<String, dynamic> json) => _$AuthorAttributionFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorAttributionToJson(this);
}