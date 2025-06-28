import 'package:intl/intl.dart';

extension IsoStringToDateExtension on String {
  String isoStringToShortFormat() {
    try {
      final date = DateTime.parse(this);
      return DateFormat('yy.MM.dd').format(date);
    } catch(_) {
      return this;
    }
  }
}