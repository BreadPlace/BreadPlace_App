import 'dart:async';
import 'package:flutter/cupertino.dart';

/// Stream에서 이벤트가 발생할 때마다 [notifyListeners]를 호출하는 클래스
/// Bloc의 상태 스트림 변화를 GoRouter 에게 전달해주기 위해 사용
/// ex) 로그인 상태에 따라 화면 이동
class StreamToListenable extends ChangeNotifier {
  late final List<StreamSubscription> subscriptions; // Stream 구독 정보를 담는 리스트

  StreamToListenable(List<Stream> blocStreams) {
    subscriptions = [];

    // 각 Stream 을 broadcast 형태로 변환하여 여러 리스너가 동시에 사용할 수 있도록 함 (다중 구독)
    for (var stream in blocStreams) {
      var subscription = stream.asBroadcastStream().listen(_onStreamEvent);
      subscriptions.add(subscription);
    }

    // 초기 로그인 상태 전달
    notifyListeners();
  }

  @override
  void dispose() {
    // 구독 취소
    for (var e in subscriptions) {
      e.cancel();
    }
    super.dispose();
  }

  void _onStreamEvent(event) => notifyListeners();
}
