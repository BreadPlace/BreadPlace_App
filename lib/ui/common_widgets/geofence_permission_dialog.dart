import 'package:bread_place/ui/permission/bloc/permission_bloc.dart';
import 'package:bread_place/ui/permission/bloc/permission_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common_dialog.dart';

// buildContext는 이 다이얼로그를 호출하는 위젯의 context여야 함
void showAppPermissionDialog(BuildContext buildContext) {
  showDialog(
    context: buildContext, // 전달받은 context 사용
    barrierDismissible: false,
    builder: (dialogContext) => CommonDialog(
      title: '알림 기능 사용 안내',
      content: '좋아하는 빵집의 알림을 받으려면 아래 권한이 필수입니다. 설정에서 권한을 허용해주세요.\n\n'
          '📍 위치 (항상 허용)\n'
          '🔔 알림',
      positiveButtonText: '권한 설정',
      onTapPositiveButton: () {
        buildContext.read<PermissionBloc>().add(EnsureGeofencePermission());
        Navigator.of(dialogContext).pop();
      },
      negativeButtonText: '닫기',
      onTapNegativeButton: () {
        Navigator.of(dialogContext).pop();
      },
    ),
  );
}