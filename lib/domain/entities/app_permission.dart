enum AppPermission {
  location,
  locationAlways,
  camera,
  notification,
}

enum AppPermissionStatus {
  granted,
  denied,
  permanentlyDenied, // 권한 거부 + 다시 묻지 않기

  // iOS 전용
  restricted, // OS 또는 관리자 설정에 의해 권한 제한
  limited, // 사진 권한 일부만 허용됨 (iOS 14+)
  provisional, // 푸시 알림에 한해 임시 허용 (iOS 12+)
}