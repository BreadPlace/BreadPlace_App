class GeofenceLimitExceededException implements Exception {
  final String message;
  GeofenceLimitExceededException([this.message = '알림은 최대 20개까지만 등록할 수 있습니다.']);

  @override
  String toString() => message;
}