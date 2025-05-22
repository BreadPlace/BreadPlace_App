class Bakery {
  final String displayName;
  final String languageCode;
  final String formattedAddress;
  final String formattedPhoneNumber;
  final Location location;
  final Viewport viewport;
  final String id;
  final PlusCode plusCode;
  final String uri; // googleMapsUri
  final List<String> types;
  final String photos;

  Bakery({
    required this.displayName,
    required this.languageCode,
    required this.formattedAddress,
    required this.formattedPhoneNumber,
    required this.location,
    required this.viewport,
    required this.id,
    required this.plusCode,
    required this.uri,
    required this.types,
    required this.photos,
  });
}


class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});
}

class Viewport {
  final Location low;
  final Location high;

  Viewport({required this.low, required this.high});
}

class PlusCode {
  final String globalCode;
  final String compoundCode;

  PlusCode({required this.globalCode, required this.compoundCode});
}
