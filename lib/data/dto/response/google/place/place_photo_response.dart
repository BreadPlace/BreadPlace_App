import 'package:json_annotation/json_annotation.dart';

part 'place_photo_response.g.dart';

@JsonSerializable()
class PlacePhotoResponse {
  final String? name;
  final String? photoUri;

  PlacePhotoResponse({this.name, this.photoUri});

  factory PlacePhotoResponse.fromJson(Map<String, dynamic> json) => _$PlacePhotoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PlacePhotoResponseToJson(this);
}