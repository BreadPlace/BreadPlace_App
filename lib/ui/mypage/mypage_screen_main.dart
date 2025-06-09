import 'package:flutter/material.dart';

import 'package:bread_place/data/services/notification/local_notification_service.dart';
import 'package:bread_place/ui/common_widgets/common_dialog.dart';

import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class MypageScreenMain extends StatefulWidget {
  const MypageScreenMain({super.key});

  @override
  State<MypageScreenMain> createState() => _MypageScreenMainState();
}

class _MypageScreenMainState extends State<MypageScreenMain> {
  @override
  void initState() {
    super.initState();

    // 첫 프레임 렌더링 이후 권한 체크 및 다이얼로그 호출
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNotificationPermission();
    });
  }

  Future<void> _checkNotificationPermission() async {
    final granted = await LocalNotificationService.ensurePermissionGranted();

    if (!mounted) return;

    if (!granted) {
      showDialog(
        context: context,
        builder:
            (_) => CommonDialog(
              title: '알람 권한 필요',
              content: '알림 기능을 사용하려면 권한을 허용해주세요. 휴대폰 설정 화면으로 이동하시겠습니까?',
              onTapNegativeButton: () {
                context.pop();
              },
              onTapPositiveButton: () {
                openAppSettings();
              },
              positiveButtonText: '이동',
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () async {
            print('3초 뒤 알림 예정...');

            // 백그라운드로 전환할 시간 확보
            Future.delayed(const Duration(seconds: 3), () {
              LocalNotificationService.showNotification(
                body: '테스트 알림',
                title: '',
                payload: '',
              );
            });
          },
          child: const Text("3초 뒤 PUSH 알림 테스트"),
        ),
      ],
    );
  }
}
