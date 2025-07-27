class RecommendBakeryException implements Exception {
  final String message;
  RecommendBakeryException([this.message = '추천 빵집이 없어요']);

  @override
  String toString() => message;
}