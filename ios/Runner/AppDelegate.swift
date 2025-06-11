import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    if let key = Bundle.main.infoDictionary?["GOOGLE_CLOUD_KEY"] as? String {
       GMSServices.provideAPIKey(key)
    }
    
    if let kakaoKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String {
        GMSServices.provideAPIKey(kakaoKey)
    }

    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
