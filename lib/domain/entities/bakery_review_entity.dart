class BakeryReviewEntity {
  final String bakeryId;
  final String bakeryName;
  final String writerId;
  final String writerNickName;
  final String recommendBread;
  final int rating;
  final String reviewContent;
  final String? imageUrl;
  final String createdAt;

  BakeryReviewEntity({
    required this.bakeryId,
    required this.bakeryName,
    required this.writerId,
    required this.writerNickName,
    required this.recommendBread,
    required this.rating,
    required this.reviewContent,
    this.imageUrl,
    required this.createdAt,
  });
}
