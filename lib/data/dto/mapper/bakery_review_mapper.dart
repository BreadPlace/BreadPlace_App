import 'package:bread_place/data/dto/response/firebase/bakery_review_dto.dart';
import 'package:bread_place/domain/entities/bakery_review_entity.dart';

// Entity -> Dto 변환
extension BakeryReviewEntityMapper on BakeryReviewEntity {
  BakeryReviewDto toDto() {
    return BakeryReviewDto(
        bakeryId: bakeryId,
        writerId: writerId,
        writerNickName: writerNickName,
        recommendBread: recommendBread,
        rating: rating,
        reviewText: reviewContent,
        imageUrl: imageUrl,
        createdAt: createdAt,
    );
  }  
}

// Dto -> Entity 변환
extension BakeryReviewDtoMapper on BakeryReviewDto {
  BakeryReviewEntity toEntity(){
    return BakeryReviewEntity(
        bakeryId: bakeryId,
        writerId: writerId,
        writerNickName: writerNickName,
        recommendBread: recommendBread,
        rating: rating,
        reviewContent: reviewText,
        imageUrl: imageUrl,
        createdAt: createdAt
    );
  }
}