package com.bp.breadplace.geofence


// 코루틴 사용을 위한 관련 패키지 임포트
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel

// 안드로이드 서비스 및 시스템 관련 클래스
import android.app.Service
import android.content.Intent
import android.content.Context
import android.os.Build
import android.os.IBinder
import android.os.Looper
import android.annotation.SuppressLint
import android.util.Log

// ForegroundService 실행을 위한 알림 관련 클래스
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import androidx.core.app.NotificationCompat

// 위치 추적 관련 Google Play Services 클래스
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices

class LocationForegroundService : Service() {
    // 백그라운드에서 위치 요청 및 작업을 처리할 코루틴 스코프
    private val serviceScope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    // 위치 제공 클라이언트
    private lateinit var fusedLocationClient: FusedLocationProviderClient

    // 콜백 객체
    private lateinit var locationCallback: LocationCallback

    override fun onCreate() {
        super.onCreate()
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        // 알림 채널 생성
        NotificationHelper.createNotificationChannel(this)
        startForegroundService()
        startLocationUpdates()
    }

    // Foreground 서비스를 시작하고, 사용자에게 위치 추적 중임을 알리는 Notification 생성
    private fun startForegroundService() {
        val notification = NotificationCompat.Builder(this, NotificationConstants.CHANNEL_ID)
            .setContentTitle("위치 정보 사용 중")
            .setContentText("저장한 빵집에 가까워지면 알려드리기 위해 사용자의 위치 정보를 사용하고 있습니다.")
            .setSmallIcon(android.R.drawable.ic_menu_mylocation)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()

        startForeground(1, notification)
    }


    // 위치 업데이트를 요청하는 메서드
    @SuppressLint("MissingPermission")
    private fun startLocationUpdates() {
        // 위치 요청 설정
        val locationRequest = LocationRequest.create().apply {
            interval = 300_000        // 위치 요청 간격: 5분 (300,000 ms)
            fastestInterval = 150_000 // 최단 수신 간격: 2분 30초 (150,000 ms)
            priority = LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY
        }

        // 콜백 정의 및 참조 유지
        locationCallback = object : LocationCallback() {
            override fun onLocationResult(result: LocationResult) {
                result.lastLocation?.let { location ->
                    Log.d("Geo", "위치 수신: ${location.latitude}, ${location.longitude}")
                }
            }
        }

        fusedLocationClient.requestLocationUpdates(
            locationRequest,
            locationCallback,
            Looper.getMainLooper()
        )
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        serviceScope.cancel()
        fusedLocationClient.removeLocationUpdates(locationCallback)
        super.onDestroy()
    }
}