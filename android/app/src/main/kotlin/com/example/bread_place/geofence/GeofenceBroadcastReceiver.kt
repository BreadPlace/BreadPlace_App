package com.example.bread_place.geofence

// Android 기본 시스템 관련
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import android.os.Build
import android.annotation.SuppressLint

// Google Play Services - Geofencing 및 위치 관련
import com.google.android.gms.location.GeofenceStatusCodes
import com.google.android.gms.location.GeofencingEvent
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofencingRequest
import com.google.android.gms.location.GeofencingClient
import com.google.android.gms.location.LocationServices

import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.example.bread_place.geofence.NotificationHelper
import com.example.bread_place.MainActivity


// 사용자가 등록된 위치에 들어가거나 나갈 때 호출되는 클래스
class GeofenceBroadcastReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "Geo"
        private const val CHANNEL_ID = NotificationConstants.CHANNEL_ID
        private const val NOTIFICATION_ID_ENTER = 2
        private const val NOTIFICATION_ID_EXIT = 3
    }

    @SuppressLint("MissingPermission")
    override fun onReceive(context: Context, intent: Intent) {
        val serviceIntent = Intent(context, LocationForegroundService::class.java).apply {
            putExtras(intent)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(serviceIntent)
        } else {
            context.startService(serviceIntent)
        }

        val geofencingEvent = GeofencingEvent.fromIntent(intent)
        if (geofencingEvent == null) {
            Log.e(TAG, "GeofencingEvent is null")
            return
        }
        if (geofencingEvent.hasError()) {
            val errorMessage = GeofenceStatusCodes.getStatusCodeString(geofencingEvent.errorCode)
            Log.e(TAG, "Geofencing error: $errorMessage")
            return
        }

        when (val transition = geofencingEvent.geofenceTransition) {
            Geofence.GEOFENCE_TRANSITION_ENTER -> {
                val geofences = geofencingEvent.triggeringGeofences ?: return
                for (geofence in geofences) {
                    val id = geofence.requestId
                    MainActivity.eventSink?.success(id) // 플러터로 전송
                    Log.d(TAG, "Geofence 진입 $id")
                }
            }

            else -> {
                Log.e(TAG, "진입 이벤트 외 Unknown transition: $transition")
            }
        }
    }

    // 알림 출력 메서드
    private fun showNotification(context: Context, message: String, notificationId: Int) {
        val builder = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_menu_mylocation)
            .setContentTitle("위치 서비스 실행 중")
            .setContentText(message)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)

        with(NotificationManagerCompat.from(context)) {
            notify(notificationId, builder.build())
        }
    }
}