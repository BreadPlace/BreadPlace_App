import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  LocalNotificationService(this._plugin);

  // 알림 시스템 초기화
  Future<void> init() async {
    // Android 플랫폼용 초기화 설정 (앱 아이콘 설정)
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 플랫폼용 초기화 설정 (권한 요청 여부 설정)
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings,
        );

    // 초기화 수행
    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  // 플랫폼별 기본 알림 설정 정의
  final NotificationDetails _defaultNotificationDetails = NotificationDetails(
    // 안드로이드 알림 채널을 구분하고 설명하기 위한 값
    android: AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    ),
    // 안드로이드 알림 채널을 구분하고 설명하기 위한 값
    iOS: DarwinNotificationDetails(badgeNumber: 1),
  );


  /// 사용자가 알림을 클릭했을 때 실행되는 콜백 메서드 (background 또는 foreground 상태)
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null && payload.isNotEmpty) {
      print("알림 클릭됨, 알림 데이터 = ${payload}");
    }
  }

  /// 실제 알림을 디바이스에 표시하는 메서드
  Future<void> showNotification({
    required String title,
    required String body,
    required String payload, // 클릭 시 전달할 데이터
  }) async {
    /// payload 에서 필요한 데이터 추출해서 사용하거나..

    // 알림 표시 실행
    await _plugin.show(
      0, // 전송을 취소하고 싶을 때 사용하는 알림 ID
      title,
      body,
      _defaultNotificationDetails,
      payload: payload,
    );
  }
}
