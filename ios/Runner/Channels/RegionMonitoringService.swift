//
//  RegionMonitoringService.swift
//  Runner
//
//  Created by 강건 on 7/2/25.
//

import CoreLocation

class RegionMonitoringService: NSObject {
    private let locationManager = CLLocationManager()
    private let channel: FlutterMethodChannel
    private let eventChannel: FlutterEventChannel
    private var eventSink: FlutterEventSink?
    
    init(methodChannel: FlutterMethodChannel, eventChannel: FlutterEventChannel) {
        self.channel = methodChannel
        self.eventChannel = eventChannel
        super.init()

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        self.eventChannel.setStreamHandler(self)
    }
    
    func startMonitoringRegions(coordinates: [CLLocationCoordinate2D]) {
        for (index, coordinate) in coordinates.enumerated() {
            let region = CLCircularRegion(center: coordinate, radius: 100, identifier: "\(index)")
            region.notifyOnEntry = true
            locationManager.startMonitoring(for: region)
        }
    }
    
    func stopMonitoringAllRegions() {
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
    }
}

extension RegionMonitoringService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let eventSink = eventSink else { return }
        
        let identifier = region.identifier
        
        DispatchQueue.main.async {
            eventSink(["event": "onEnterGeofencing", "regionId": identifier])
        }
    }
}

extension RegionMonitoringService: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        print("[iOS] onListen 호출됨")
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
