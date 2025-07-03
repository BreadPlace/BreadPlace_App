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

    // 현재 관리 중인 Geofence 객체들을 저장하는 맵 (Key: Geofence ID, Value: Geofence 객체)
    private val geofenceList = mutableMapOf<String, Geofence>()


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
     * Geofence 객체를 생성하여 geofenceList에 추가합니다.
     * 실제 시스템 등록은 registerGeofence()를 별도로 호출해야 합니다.
     */
    fun addGeofence(
        key: String,
        location: Location,
        radiusInMeters: Float = 100.0f, // 감지 반경, 기본값 100m
    ) {
        // Geofence 객체를 생성하여 리스트에 추가
        geofenceList[key] = createGeofence(key, location, radiusInMeters)
        Log.d(TAG, "Geofence 추가됨: ID=$key, 위치=(${location.latitude}, ${location.longitude}), 반경=${radiusInMeters}m")
    }

    /**
     * 등록된 Geofence를 geofenceList에서 제거합니다.
     * 실제 시스템에서 해제하려면 deregisterGeofence()를 호출해야 합니다.
     */
    fun removeGeofence(key: String) {
        geofenceList.remove(key)
        Log.d(TAG, "Geofence 제거됨: ID=$key")
    }

    /**
     * 현재 geofenceList에 있는 모든 Geofence를 시스템에 등록합니다.
     * 등록하기 전에 addGeofence()로 목록을 구성해야 합니다.
     *
     * 주의: 이 메서드는 위치 권한(ACCESS_FINE_LOCATION)이 필요합니다.
     * 권한이 없으면 SecurityException이 발생할 수 있습니다.
     */
    @SuppressLint("MissingPermission")
    fun registerGeofence() {
        // 등록할 Geofence가 없는 경우 처리
        if (geofenceList.isEmpty()) {
            Log.w(TAG, "등록할 Geofence가 없습니다.")
            return
        }

        client.addGeofences(createGeofencingRequest(), geofencingPendingIntent)
            .addOnSuccessListener {
                // 등록 성공 시 로그 출력
                Log.d(TAG, "Geofence 등록 성공. 총 ${geofenceList.size}개 등록됨")
                geofenceList.keys.forEach { id ->
                    Log.d(TAG, "등록된 Geofence ID: $id")
                }
            }
            .addOnFailureListener { exception ->
                // 등록 실패 시 에러 로그 출력
                Log.e(TAG, "Geofence 등록 실패: ${exception.message}", exception)
            }
    }

    /**
     * 시스템에 등록된 모든 Geofence를 해제하고 로컬 리스트도 초기화합니다.
     */
    suspend fun deregisterGeofence() = kotlin.runCatching {
        // 시스템에서 모든 Geofence 제거
        client.removeGeofences(geofencingPendingIntent).await()

        // 로컬 리스트 초기화
        val removedCount = geofenceList.size
        geofenceList.clear()

        Log.d(TAG, "모든 Geofence 해제 완료. 제거된 개수: $removedCount")
    }

    /**
     * GeofencingRequest 객체를 생성합니다.
     * 이 객체는 Geofence 시스템에 전달되어 트리거 설정 및 실제 등록에 사용됩니다.
     */
    private fun createGeofencingRequest(): GeofencingRequest {
        return GeofencingRequest.Builder().apply {
            setInitialTrigger(GEOFENCE_TRANSITION_ENTER)
            addGeofences(geofenceList.values.toList())
        }.build()
    }

    /**
     * 실제 Geofence 객체를 생성합니다.
     * Google Play Services의 Geofence 클래스를 사용하여 지리적 영역을 정의합니다.
     * @return Geofence 생성된 Geofence 객체
     */
    private fun createGeofence(
        key: String,
        location: Location,
        radiusInMeters: Float,
        expirationTimeInMillis: Long = Geofence.NEVER_EXPIRE,
    ): Geofence {
        return Geofence.Builder()
            .setRequestId(key)
            .setCircularRegion(
                location.latitude,   // 중심점 위도
                location.longitude,  // 중심점 경도
                radiusInMeters      // 반지름 (미터)
            )
            .setExpirationDuration(expirationTimeInMillis) // 만료 시간 설정
            .setTransitionTypes(
                // 감지할 이벤트 타입: 진입과 이탈 모두 감지
                GEOFENCE_TRANSITION_ENTER or
                        GEOFENCE_TRANSITION_EXIT
            )
            .build()
    }


    fun getGeofenceList(): Map<String, Geofence> {
        return geofenceList.toMap() // 원본 수정을 방지하기 위해 복사본 반환
    }
}