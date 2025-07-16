import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // MARK: Settings
        
        // 구글 키 설정
        if let key = Bundle.main.infoDictionary?["GOOGLE_CLOUD_KEY"] as? String {
            GMSServices.provideAPIKey(key)
        }
        
        // 카카오 키 설정
        if let kakaoKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String {
            GMSServices.provideAPIKey(kakaoKey)
        }
        
        // 알림 설정
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        
        
        // MARK: Method Channels
        // Method Channel을 사용하기 위한 Controller 선언
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let regionMonitoringChannelName: String = "com.bread_place.geofencing/method"
        let regionMonitoringEventChannelName: String = "com.bread_place.geofencing/event"
        
        let regionMonitoringChannel = FlutterMethodChannel(
            name: regionMonitoringChannelName,
            binaryMessenger: controller.binaryMessenger
        )
        
        let regionMonitoringEventChannel = FlutterEventChannel(
            name: regionMonitoringEventChannelName,
            binaryMessenger: controller.binaryMessenger
        )

        let regionService = RegionMonitoringService(
            methodChannel: regionMonitoringChannel,
            eventChannel: regionMonitoringEventChannel
        )

        regionMonitoringChannel.setMethodCallHandler { [weak self] call, result in
            guard let self else { return }
            
            switch call.method {
            case "setGeofencingLocation":
                // 전달받은 값이 문자열 배열이 아닌 경우 플러터 에러 리턴
                guard let stringList = call.arguments as? [String] else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected list of strings", details: nil))
                    return
                }

                // RegionInfo 타입으로 디코딩
                let regionInfos = self.decodeToRegionInfos(stringList: stringList)
                
                // 좌표값으로 지오펜싱 동작
                regionService.startMonitoringRegions(regionInfos: regionInfos)
                result("Region set")
        
            case "stopGeofencingLocation":
                regionService.stopMonitoringAllRegions()
                result("Region stop")
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

extension AppDelegate {
    /// ["ID|Name|Latitude|Longitude"] 형태의 배열을 RegionInfo 타입으로 디코딩하는 함수
    func decodeToRegionInfos(stringList: [String]) -> [RegionInfo] {
        return stringList.compactMap { deliveredString in
            let parts = deliveredString.split(separator: "|")
            
            guard parts.count == 4,
                  let latitude = Double(parts[2]),
                  let longitude = Double(parts[3])
            else {
                return nil
            }
            
            let id = String(parts[0])
            let name = String(parts[1])
            
            return RegionInfo(id: id, name: name, latitude: latitude, longitude: longitude)
        }
    }
}
