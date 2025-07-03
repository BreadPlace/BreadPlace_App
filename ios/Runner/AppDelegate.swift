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

        var regionService = RegionMonitoringService(
            methodChannel: regionMonitoringChannel,
            eventChannel: regionMonitoringEventChannel
        )

        regionMonitoringChannel.setMethodCallHandler { [weak self] call, result in
            guard let self = self else { return }
            
            switch call.method {
            case "setGeofencingLocation":
                // 전달받은 값이 문자열 배열이 아닌 경우 리턴
                guard let stringList = call.arguments as? [String] else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected list of strings", details: nil))
                    return
                }
                
                // 전달받은 값 좌표값으로 디코딩
                let coordinates: [CLLocationCoordinate2D] = stringList.compactMap { point in
                    let parts = point.split(separator: ",").map{$0.trimmingCharacters(in: .whitespaces)}
                    
                    guard parts.count == 2,
                          let latitude = Double(parts[0]),
                          let longitude = Double(parts[1])
                    else {
                        return nil
                    }
                    
                    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
                
                // 좌표값으로 지오펜싱 동작
                regionService.startMonitoringRegions(coordinates: coordinates)
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
