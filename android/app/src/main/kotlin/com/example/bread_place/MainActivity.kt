package com.example.bread_place

// Flutter 연동 관련
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel

// Android 권한 및 시스템 관련
import android.Manifest
import android.annotation.SuppressLint
import android.location.Location
import android.os.Build
import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

// Android 위치 및 인텐트 관련
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle

import android.app.NotificationChannel
import android.app.NotificationManager

import com.example.bread_place.geofence.NotificationHelper
import com.example.bread_place.geofence.GeofenceBroadcastReceiver
import com.example.bread_place.geofence.GeofenceManager
import com.example.bread_place.geofence.LocationForegroundService

class MainActivity : FlutterActivity() {
    companion object {
        // Flutter로 이벤트를 전달하기 위해 사용하는 데이터 전송 인터페이스
        var onEnterGeofencing: EventChannel.EventSink? = null
    }

    private lateinit var geofenceManager: GeofenceManager
    private val METHOD_CHANNEL = "com.bread_place.geofencing/method"
    private val EVENT_CHANNEL = "com.bread_place.geofencing/event"


    // Flutter 엔진 구성
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Geofence 감지 시, 포그라운드 서비스 실행하면 시스템 알림을 반드시 표시 해야함
        NotificationHelper.createNotificationChannel(this)
        geofenceManager = GeofenceManager(this)

        setupMethodChannel(flutterEngine)
        setupEventChannel(flutterEngine)
    }

    // MethodChannel 설정 (Flutter -> Android)
    private fun setupMethodChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setGeofencing" -> {
                        // Flutter에서 전달받은 파라미터들을 추출
                        val regionList = call.arguments as? List<*> ?: run {
                            result.error("INVALID_ARGUMENT", "List<String> expected", null)
                            return@setMethodCallHandler
                        }

                        val locations = parseRegionStringsToLocations(regionList)

                        if (locations.isEmpty()) {
                            result.error("NO_VALID_LOCATIONS", "No valid lat/lon pairs found", null)
                            return@setMethodCallHandler
                        }

                        CoroutineScope(Dispatchers.IO).launch {
                            try {
                                geofenceManager.updateGeofences(locations)
                                startLocationForegroundService(this@MainActivity)
                                runOnUiThread { result.success("Geofence 등록 완료") }
                            } catch (e: Exception) {
                                runOnUiThread { result.error("GEOFENCE_ERROR", e.message, null) }
                            }
                        }
                    }

                    "removeGeofencing" -> {
                        CoroutineScope(Dispatchers.IO).launch {
                            try {
                                geofenceManager.removeAllGeofences()
                                stopLocationForegroundService(this@MainActivity)
                                runOnUiThread { result.success("Geofence 해제 완료") }
                            } catch (e: Exception) {
                                runOnUiThread { result.error("GEOFENCE_REMOVE_ERROR", e.message, null) }
                            }
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }

    // EventChannel 설정 (Android -> Flutter)
    private fun setupEventChannel(flutterEngine: FlutterEngine) {
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    onEnterGeofencing = events
                }
                override fun onCancel(arguments: Any?) {
                    onEnterGeofencing = null
                }
            }
        )
    }

    // 문자열 리스트를 Location 객체 리스트로 변환하는 함수
    private fun parseRegionStringsToLocations(regionList: List<*>): List<Location> {
        val locations = mutableListOf<Location>()

        for (region in regionList) {
            val parts = (region as? String)?.split(",") ?: continue
            if (parts.size != 2) continue

            val latitude = parts[0].trim().toDoubleOrNull() ?: continue
            val longitude = parts[1].trim().toDoubleOrNull() ?: continue

            val location = Location("").apply {
                this.latitude = latitude
                this.longitude = longitude
            }

            locations.add(location)
        }

        return locations
    }

    // Foreground 서비스를 시작하는 함수
    private fun startLocationForegroundService(context: Context) {
        val serviceIntent = Intent(context, LocationForegroundService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(serviceIntent)
        } else {
            context.startService(serviceIntent)
        }
    }

    // Foreground 서비스를 중지하는 함수
    private fun stopLocationForegroundService(context: Context) {
        val serviceIntent = Intent(context, LocationForegroundService::class.java)
        context.stopService(serviceIntent)
    }
}
