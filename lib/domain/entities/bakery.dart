class Bakery {
  final String displayName;
  final String languageCode;
  final String formattedAddress;
  final String formattedPhoneNumber;
  final String location;
  final String viewPort;
  final String id;
  final String plusCode;
  final String uri; // googleMapsUri
  final List<String> types;
  final List<String> photos;

  Bakery({
    required this.displayName,
    required this.languageCode,
    required this.formattedAddress,
    required this.formattedPhoneNumber,
    required this.location,
    required this.viewPort,
    required this.id,
    required this.plusCode,
    required this.uri,
    required this.types,
    required this.photos,
  });
}
