class Bakery {
  final String displayName;
  final String languageCode;
  final String formattedAddress;
  final String formattedPhoneNumber;
  final Location location;
  final Viewport viewport;
  final String id;
  final PlusCode plusCode;
  final List<String> types;
  final String googleMapsUri;
  String photoUri;
  String photoId;

  Bakery({
    required this.displayName,
    required this.languageCode,
    required this.formattedAddress,
    required this.formattedPhoneNumber,
    required this.location,
    required this.viewport,
    required this.id,
    required this.plusCode,
    required this.types,
    required this.googleMapsUri,
    required this.photoUri,
    required this.photoId,
  });
}


class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  static Location empty() => Location(latitude: 0.0, longitude: 0.0);
}

class Viewport {
  final Location low;
  final Location high;

  Viewport({required this.low, required this.high});

  static Viewport empty() => Viewport(
    low: Location.empty(),
    high: Location.empty(),
  );
}

class PlusCode {
  final String globalCode;
  final String compoundCode;

  PlusCode({required this.globalCode, required this.compoundCode});

  static PlusCode empty() => PlusCode(globalCode: '', compoundCode: '');
}
