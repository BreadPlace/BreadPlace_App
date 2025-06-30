package com.example.bread_place

// Android 기본 시스템 관련
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Log

// Google Play Services - Geofencing 및 위치 관련
import com.google.android.gms.location.GeofenceStatusCodes
import com.google.android.gms.location.GeofencingEvent
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofencingRequest
import com.google.android.gms.location.GeofencingClient
import com.google.android.gms.location.LocationServices

// 사용자가 등록된 위치에 들어가거나 나갈 때 호출되는 클래스
class GeofenceBroadcastReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        Log.d("GeofenceReceiver", "onReceive called")  // 수신 로그

        val event = GeofencingEvent.fromIntent(intent)
        if (event == null) {
            Log.e("GeofenceReceiver", "GeofencingEvent is null")
            return
        }

        if (event.hasError()) {
            val errorMessage = GeofenceStatusCodes.getStatusCodeString(event.errorCode)
            Log.e("GeofenceReceiver", "Geofence error: $errorMessage")
            return
        }

        val transitionType = event.geofenceTransition
        val triggeringGeofences = event.triggeringGeofences ?: emptyList()

        Log.d("GeofenceReceiver", "TransitionType: $transitionType")

        for (geofence in triggeringGeofences) {
            val id = geofence.requestId
            when (transitionType) {
                Geofence.GEOFENCE_TRANSITION_ENTER ->
                    Log.d("GeofenceReceiver", "Entered geofence: $id")
                Geofence.GEOFENCE_TRANSITION_EXIT ->
                    Log.d("GeofenceReceiver", "Exited geofence: $id")
                else ->
                    Log.d("GeofenceReceiver", "Other transition for $id: $transitionType")
            }
        }
    }
}