class Place {
  final String id;
  final String name;
  final String roadAddress;
  final String placeUrl;
  final String? distance;
  final String categoryName;
  final String imagePath;
  final String? categoryGroupCode;

  Place({
    required this.id,
    required this.name,
    required this.roadAddress,
    required this.placeUrl,
    required this.distance,
    required this.categoryName,
    required this.imagePath,
    required this.categoryGroupCode
  });
}