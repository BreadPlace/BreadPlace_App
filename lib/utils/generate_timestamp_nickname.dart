String generateTimestampNickname({String prefix = '빵플레이스'}) {
  final now = DateTime.now();
  final formatted = '${now.year}${_two(now.month)}${_two(now.day)}'
      '${_two(now.hour)}${_two(now.minute)}'
      '${_two(now.second)}${now.millisecond.toString().padLeft(3, '0')}';
  return '$prefix$formatted';
}

String _two(int value) => value.toString().padLeft(2, '0');