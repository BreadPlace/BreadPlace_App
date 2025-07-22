import 'package:json_annotation/json_annotation.dart';

part 'bakery_review_dto.g.dart';

@JsonSerializable()
class BakeryReviewDto{
  final String bakeryId;
  final String bakeryName;
  final String writerId;
  final String writerNickName;
  final String recommendBread;
  final int rating;
  final String reviewText;
  final String? imageUrl;
  final String createdAt;

  BakeryReviewDto({
    required this.bakeryId,
    required this.bakeryName,
    required this.writerId,
    required this.writerNickName,
    required this.recommendBread,
    required this.rating,
    required this.reviewText,
    required this.imageUrl,
    required this.createdAt,
  });

  factory BakeryReviewDto.fromJson(Map<String, dynamic> json) => _$BakeryReviewDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BakeryReviewDtoToJson(this);
}