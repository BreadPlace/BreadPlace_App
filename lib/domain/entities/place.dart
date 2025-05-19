class Place {
  final String id;
  final String name;
  final String roadAddress;
  final String placeUrl;
  final String? distance;
  final String categoryName;
  final String imagePath;
  final String? categoryGroupCode;
  final String? x; // longitude
  final String? y; // latitude

  Place({
    required this.id,
    required this.name,
    required this.roadAddress,
    required this.placeUrl,
    this.distance,
    required this.categoryName,
    required this.imagePath,
    this.categoryGroupCode,
    this.x,
    this.y
  });
}