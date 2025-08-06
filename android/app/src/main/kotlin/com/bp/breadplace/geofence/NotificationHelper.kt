package com.bp.breadplace.geofence

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build

// 알림 채널 관련 상수 정의
object NotificationConstants {
    const val CHANNEL_ID = "location_channel"
    const val CHANNEL_NAME = "위치 서비스 알림"
    const val CHANNEL_DESCRIPTION = "지오펜싱 및 위치 서비스 알림을 위한 채널"
}

// 알림을 표시하기 위해 필수적으로 알림 채널을 생성합니다.
object NotificationHelper {
    fun createNotificationChannel(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                NotificationConstants.CHANNEL_ID,
                NotificationConstants.CHANNEL_NAME,
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = NotificationConstants.CHANNEL_DESCRIPTION
            }
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
}