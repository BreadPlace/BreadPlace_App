// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bakery_review_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BakeryReviewDto _$BakeryReviewDtoFromJson(Map<String, dynamic> json) =>
    BakeryReviewDto(
      bakeryId: json['bakeryId'] as String,
      bakeryName: json['bakeryName'] as String,
      writerId: json['writerId'] as String,
      writerNickName: json['writerNickName'] as String,
      recommendBread: json['recommendBread'] as String,
      rating: (json['rating'] as num).toInt(),
      reviewText: json['reviewText'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$BakeryReviewDtoToJson(BakeryReviewDto instance) =>
    <String, dynamic>{
      'bakeryId': instance.bakeryId,
      'bakeryName': instance.bakeryName,
      'writerId': instance.writerId,
      'writerNickName': instance.writerNickName,
      'recommendBread': instance.recommendBread,
      'rating': instance.rating,
      'reviewText': instance.reviewText,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt,
    };
