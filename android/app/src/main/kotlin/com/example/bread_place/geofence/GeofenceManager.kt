package com.example.bread_place.geofence

// Android 기본 시스템 관련
import android.annotation.SuppressLint
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.location.Location
import android.os.Build
import android.util.Log

// Google Play Services - 위치 및 지오펜싱 관련
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.Geofence.GEOFENCE_TRANSITION_ENTER
import com.google.android.gms.location.Geofence.GEOFENCE_TRANSITION_EXIT
import com.google.android.gms.location.GeofencingRequest
import com.google.android.gms.location.LocationServices

// Kotlin Coroutine - 비동기 작업 관련
import kotlinx.coroutines.tasks.await

/**
 * Geofence를 실제로 등록하고 관리하는 클래스
 * Google Play Services Location API를 사용하여 지리적 영역 감지 기능을 제공합니다.
 */
class GeofenceManager(private val context: Context) {
    private val client = LocationServices.getGeofencingClient(context)

    companion object {
        // 로그 태그
        private const val TAG = "GeofenceManager"
    }

    // Geofence 이벤트 발생시 Android 시스템이 호출하는 PendingIntent
    private val geofencingPendingIntent: PendingIntent by lazy {
        val intent = Intent(context, GeofenceBroadcastReceiver::class.java)

        PendingIntent.getBroadcast(
            context,
            0,
            intent,
            PendingIntent.FLAG_MUTABLE
        )
    }


    /**
     * 전달받은 GeofenceLocationModel 목록을 기반으로 지오펜스를 등록합니다.
     *
     * 주의: 이 메서드는 위치 권한(ACCESS_FINE_LOCATION)이 필요합니다.
     * 권한이 없으면 SecurityException이 발생할 수 있습니다.
     */
    @SuppressLint("MissingPermission")
    suspend fun updateGeofences(locations: List<GeofenceLocationModel>) {
        try {
            // 기존 지오펜스 해제
            client.removeGeofences(geofencingPendingIntent).await()
            Log.d(TAG, "기존 Geofence 모두 해제 완료")

            if (locations.isEmpty()) {
                Log.w(TAG, "등록할 위치 리스트가 비어있음")
                return
            }

            // 새 Geofence 리스트 생성
            val geofences = locations.map { model ->
                createGeofence(
                    key = model.placeId,
                    latitude = model.latitude,
                    longitude = model.longitude,
                    radiusInMeters = 100f
                )
            }

            // 새 Geofence 등록
            client.addGeofences(createGeofencingRequest(geofences), geofencingPendingIntent)
                .addOnSuccessListener {
                    Log.d(TAG, "새 Geofence 등록 성공. 총 ${geofences.size}개")
                }
                .addOnFailureListener { e ->
                    Log.e(TAG, "Geofence 등록 실패: ${e.message}", e)
                }
                .await()

        } catch (e: Exception) {
            Log.e(TAG, "Geofence 갱신 중 오류 발생: ${e.message}", e)
        }
    }


    /**
     * GeofencingRequest 객체를 생성합니다.
     * 이 객체는 Geofence 시스템에 전달되어 트리거 설정 및 실제 등록에 사용됩니다.
     */
    private fun createGeofencingRequest(geofences: List<Geofence>): GeofencingRequest {
        return GeofencingRequest.Builder().apply {
            setInitialTrigger(GEOFENCE_TRANSITION_ENTER or GEOFENCE_TRANSITION_EXIT)
            addGeofences(geofences)
        }.build()
    }

    /**
     * 주어진 좌표로 Geofence 객체를 생성합니다.
     */
    private fun createGeofence(
        key: String,
        latitude: Double,
        longitude: Double,
        radiusInMeters: Float,
        expirationTimeInMillis: Long = Geofence.NEVER_EXPIRE,
    ): Geofence {
        return Geofence.Builder()
            .setRequestId(key)
            .setCircularRegion(latitude, longitude, radiusInMeters)
            .setExpirationDuration(expirationTimeInMillis)
            .setTransitionTypes(GEOFENCE_TRANSITION_ENTER or GEOFENCE_TRANSITION_EXIT)
            .build()
    }

    suspend fun removeAllGeofences() {
        try {
            client.removeGeofences(geofencingPendingIntent).await()
            Log.d(TAG, "Geofence 모두 해제 완료")
        } catch (e: Exception) {
            Log.e(TAG, "Geofence 해제 중 오류 발생: ${e.message}", e)
        }
    }
}