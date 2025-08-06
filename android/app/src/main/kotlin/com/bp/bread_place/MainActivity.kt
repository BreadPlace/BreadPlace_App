package com.bp.bread_place

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

import com.bp.bread_place.geofence.NotificationHelper
import com.bp.bread_place.geofence.GeofenceBroadcastReceiver
import com.bp.bread_place.geofence.GeofenceManager
import com.bp.bread_place.geofence.LocationForegroundService
import com.bp.bread_place.geofence.GeofenceLocationModel

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
                    "setGeofencingLocation" -> {
                        // Flutter에서 전달받은 파라미터들을 추출
                        val regionList = call.arguments as? List<*> ?: run {
                            result.error("INVALID_ARGUMENT", "List<String> expected", null)
                            return@setMethodCallHandler
                        }

                        val geofenceLocations = parseRegionStringsToGeofenceLocations(regionList)

                        if (geofenceLocations.isEmpty()) {
                            result.error("NO_VALID_LOCATIONS", "No valid geofence data found", null)
                            return@setMethodCallHandler
                        }

                        CoroutineScope(Dispatchers.IO).launch {
                            try {
                                geofenceManager.updateGeofences(geofenceLocations)
                                startLocationForegroundService(this@MainActivity)
                                runOnUiThread { result.success("Geofence 등록 완료") }
                            } catch (e: Exception) {
                                runOnUiThread { result.error("GEOFENCE_ERROR", e.message, null) }
                            }
                        }
                    }

                    "stopGeofencingLocation" -> {
                        CoroutineScope(Dispatchers.IO).launch {
                            try {
                                geofenceManager.removeAllGeofences()
                                stopLocationForegroundService(this@MainActivity)
                                runOnUiThread { result.success("Geofence 해제 완료") }
                            } catch (e: Exception) {
                                runOnUiThread {
                                    result.error(
                                        "GEOFENCE_REMOVE_ERROR",
                                        e.message,
                                        null
                                    )
                                }
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

    // 문자열 리스트를 GeofenceLocationModel 리스트로 변환하는 함수
    private fun parseRegionStringsToGeofenceLocations(regionList: List<*>): List<GeofenceLocationModel> {
        val geofenceLocations = mutableListOf<GeofenceLocationModel>()

        for (region in regionList) {
            val regionStr = region as? String ?: continue
            val parts = regionStr.split("|")

            if (parts.size != 4) continue

            val placeId = parts[0]
            val name = parts[1]
            val latitude = parts[2].toDoubleOrNull() ?: continue
            val longitude = parts[3].toDoubleOrNull() ?: continue

            geofenceLocations.add(
                GeofenceLocationModel(
                    placeId = placeId,
                    name = name,
                    latitude = latitude,
                    longitude = longitude
                )
            )
        }
        return geofenceLocations
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
