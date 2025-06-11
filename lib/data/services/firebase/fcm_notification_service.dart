// import 'dart:convert';
// import 'package:bread_place/config/routing/router.dart';
// import 'package:bread_place/config/routing/routes.dart';
// import 'package:bread_place/data/services/notification/local_notification_service.dart';
// import 'package:bread_place/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
//
// class FcmNotificationService {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   // 알림 권한 요청
//   Future<NotificationSettings> requestPermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     return settings;
//   }
//
//   // 포그라운드 화면에서 알림을 수신하는 리스너 설정
//   void setupForegroundMessaging() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       String payloadData = jsonEncode(message.data);
//
//       ///
//       if (message.notification != null) {
//         LocalNotificationService.showNotification(
//             title: message.notification!.title ?? 'message title',
//             body: message.notification!.body ?? 'message body',
//             payload: payloadData
//         );
//       }
//
//       print('Message data: ${message.data}');
//       print('Message notification: ${message.notification?.title}');
//       print('Message notification: ${message.notification?.body}');
//       print('**************************************');
//
//       // TODO: 여기서 포그라운드 메시지 처리 로직 구현
//       // 예를 들어, local_notification을 사용해서 알림 띄우기
//       // 또는 SnackBar, Dialog 등으로 UI에 표시
//
//     });
//   }
//
//   Future<void> getFcmToken() async {
//     String? token = await FirebaseMessaging.instance.getToken();
//     print("FCM Token: $token");
//
//     // 토큰 변경 리스너 (토큰이 갱신될 때마다 호출됨)
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//       print("FCM Token Refreshed: $newToken");
//       // TODO: 새 토큰을 서버에 저장하는 로직 추가
//     });
//   }
//
//
//   // 앱이 종료되었다가 알림 탭으로 실행될 때 메시지 처리
//   Future<RemoteMessage?> getInitialMessage() async {
//     // TODO: ... getInitialMessage 로직 ...
//     return await messaging.getInitialMessage();
//   }
//
//   // 앱이 백그라운드에서 알림 탭으로 포그라운드로 전환될 때 메시지 처리
//   void setupMessageOpenedApp() {
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('FCM Service // Message opened app: ${message.messageId}');
//       // TODO: 알림 탭 시 특정 화면으로 이동하는 라우팅 로직
//     });
//   }
//
//   // 푸시 알림 메시지와 상호작용 정의
//   Future<void> setupInteractedMessage() async {
//     // 1. 앱이 종료된 상태에서 열릴 때 -> getInitialMessage 호출
//     RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       _handleMessage(initialMessage);
//     }
//
//     // 2. 앱이 백그라운드 상태일 때, 푸시 알림을 탭할 때
//     FirebaseMessaging.onMessageOpenedApp.listen((_handleMessage));
//   }
//
//   // FCM 에서 전송한 data 처리
//   void _handleMessage(RemoteMessage message) {
//     router.go(Routes.like);
//   }
// }
//
//
// // 이 함수는 클래스 안에 넣지 않고 파일의 최상위에 정의해야 함
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   print("FCM Background // Handling a background message: ${message.messageId}");
//   print('FCM Background // Message data: ${message.data}');
//   print('FCM Background // Message notification: ${message.notification?.title}');
//   print('FCM Background // Message notification: ${message.notification?.body}');
//
//   // 여기서 필요한 백그라운드 작업을 수행합니다. (예: 로컬 DB 저장, 서버에 상태 보고 등)
// }
