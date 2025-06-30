package com.example.bread_place

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
    // Google Play Services의 Geofencing 클라이언트
    private val client = LocationServices.getGeofencingClient(context)

    companion object {
        // PendingIntent를 위한 고유한 요청 코드
        const val CUSTOM_REQUEST_CODE_GEOFENCE = 1001
        // 로그 태그
        private const val TAG = "GeofenceManager"
    }

    // 현재 관리 중인 Geofence 객체들을 저장하는 맵
    // Key: Geofence ID, Value: Geofence 객체
    private val geofenceList = mutableMapOf<String, Geofence>()

    /**
     * Geofence 이벤트(진입/이탈 등)가 발생했을 때 Android 시스템이 호출하는 PendingIntent
     * 해당 인텐트는 GeofenceBroadcastReceiver를 통해 수신됩니다.
     * 명시적 인텐트를 사용하여 보안성을 높입니다.
     */
    private val geofencingPendingIntent: PendingIntent by lazy {
        val intent = Intent(context, GeofenceBroadcastReceiver::class.java)

        // Android 12 이상에서는 FLAG_IMMUTABLE 사용이 권장됩니다
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }

        PendingIntent.getBroadcast(
            context,
            CUSTOM_REQUEST_CODE_GEOFENCE,
            intent,
            flags
        )
    }

    /**
     * Geofence 객체를 생성하여 geofenceList에 추가합니다.
     * 실제 시스템 등록은 registerGeofence()를 별도로 호출해야 합니다.
     *
     * @param key 고유 식별자 (Geofence ID)
     * @param location 위치 정보 (위도/경도를 포함한 Location 객체)
     * @param radiusInMeters 감지 반경 (미터 단위, 기본값 100m)
     * @param expirationTimeInMillis 만료 시간 (밀리초 단위, 기본값 30분)
     */
    fun addGeofence(
        key: String,
        location: Location,
        radiusInMeters: Float = 100.0f,
        expirationTimeInMillis: Long = 30 * 60 * 1000, // 30분
    ) {
        // Geofence 객체를 생성하여 리스트에 추가
        geofenceList[key] = createGeofence(key, location, radiusInMeters, expirationTimeInMillis)
        Log.d(TAG, "Geofence 추가됨: ID=$key, 위치=(${location.latitude}, ${location.longitude}), 반경=${radiusInMeters}m")
    }

    /**
     * 등록된 Geofence를 geofenceList에서 제거합니다.
     * 실제 시스템에서 해제하려면 deregisterGeofence()를 호출해야 합니다.
     *
     * @param key 제거할 Geofence의 고유 식별자
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

        // Google Play Services에 Geofence 등록 요청
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
     * 코루틴을 사용하여 비동기적으로 실행됩니다.
     *
     * @return Result<Unit> 성공/실패 결과를 포함한 Result 객체
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
     *
     * @return GeofencingRequest 시스템에 전달할 요청 객체
     */
    private fun createGeofencingRequest(): GeofencingRequest {
        return GeofencingRequest.Builder().apply {
            // 초기 트리거를 진입(ENTER)으로 설정
            // 이는 Geofence가 등록된 직후 사용자가 이미 해당 영역 내에 있을 경우 즉시 트리거되도록 합니다
            setInitialTrigger(GEOFENCE_TRANSITION_ENTER)

            // 현재 관리 중인 모든 Geofence를 요청에 추가
            addGeofences(geofenceList.values.toList())
        }.build()
    }

    /**
     * 실제 Geofence 객체를 생성합니다.
     * Google Play Services의 Geofence 클래스를 사용하여 지리적 영역을 정의합니다.
     *
     * @param key 고유 식별자
     * @param location 중심점 위치
     * @param radiusInMeters 감지 반경 (미터)
     * @param expirationTimeInMillis 만료 시간 (밀리초)
     * @return Geofence 생성된 Geofence 객체
     */
    private fun createGeofence(
        key: String,
        location: Location,
        radiusInMeters: Float,
        expirationTimeInMillis: Long,
    ): Geofence {
        return Geofence.Builder()
            .setRequestId(key) // 고유 식별자 설정
            .setCircularRegion(
                location.latitude,   // 중심점 위도
                location.longitude,  // 중심점 경도
                radiusInMeters      // 반지름 (미터)
            )
            .setExpirationDuration(expirationTimeInMillis) // 만료 시간 설정
            .setTransitionTypes(
                // 감지할 이벤트 타입: 진입과 이탈 모두 감지
                GEOFENCE_TRANSITION_ENTER or GEOFENCE_TRANSITION_EXIT
            )
            .build()
    }

    /**
     * 현재 등록된 Geofence 목록을 반환합니다.
     * 디버깅이나 상태 확인 용도로 사용할 수 있습니다.
     *
     * @return Map<String, Geofence> 현재 관리 중인 Geofence 맵의 복사본
     */
    fun getGeofenceList(): Map<String, Geofence> {
        return geofenceList.toMap() // 원본 수정을 방지하기 위해 복사본 반환
    }
}