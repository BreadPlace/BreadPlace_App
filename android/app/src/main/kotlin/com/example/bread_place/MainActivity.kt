package com.example.bread_place

// Flutter 연동 관련
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// Android 권한 및 시스템 관련
import android.Manifest
import android.annotation.SuppressLint
import android.location.Location
import android.os.Build

// Android 위치 및 인텐트 관련
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle

class MainActivity : FlutterActivity() {
    private lateinit var geofenceManager: GeofenceManager

    // Flutter와 Android 간 통신을 위한 채널명
    private val CHANNEL = "com.bread_place.geofencing"

    // Flutter 엔진을 구성하고 MethodChannel을 설정합니다.
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // GeofenceManager 인스턴스 생성
        geofenceManager = GeofenceManager(this)

        // Flutter와 Android 간 메서드 채널 설정
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    // Geofence 추가 메서드
                    "addGeofence" -> {
                        // Flutter에서 전달받은 파라미터들을 추출
                        val latitude = call.argument<Double>("latitude") ?: run {
                            result.error("INVALID_ARGUMENT", "latitude is required", null)
                            return@setMethodCallHandler
                        }
                        val longitude = call.argument<Double>("longitude") ?: run {
                            result.error("INVALID_ARGUMENT", "longitude is required", null)
                            return@setMethodCallHandler
                        }
                        val radius = call.argument<Double>("radius")?.toFloat() ?: 100.0f
                        val identifier = call.argument<String>("identifier") ?: run {
                            result.error("INVALID_ARGUMENT", "identifier is required", null)
                            return@setMethodCallHandler
                        }

                        // Location 객체 생성
                        val location = Location("").apply {
                            this.latitude = latitude
                            this.longitude = longitude
                        }

                        // Geofence를 목록에 추가
                        geofenceManager.addGeofence(
                            key = identifier,
                            location = location,
                            radiusInMeters = radius
                        )

                        // 실제 시스템에 Geofence 등록
                        geofenceManager.registerGeofence()

                        // Flutter로 성공 결과 반환
                        result.success("Geofence 등록 완료")
                    }

                    // 구현되지 않은 메서드 처리
                    else -> result.notImplemented()
                }
            }
    }
}
