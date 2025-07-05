import 'dart:async';
import 'package:bread_place/config/constants/app_constants.dart';
import 'package:flutter/services.dart';

class GeofencingService {
  final MethodChannel geofencingChannel;
  final EventChannel geofencingEventChannel;

  final StreamController<String> _geofencingEnteredController = StreamController.broadcast();
  Stream<String> get onGeofencingEntered => _geofencingEnteredController.stream;

  GeofencingService({
    required this.geofencingChannel,
    required this.geofencingEventChannel
  });

  Future<void> init() async {
    _initEventListener();
  }

  Future<void> setGeofencingLocations(List<String> locations) async {
    try {
      await geofencingChannel.invokeMethod(AppConstants.setGeofencingMethodName, locations);
    } on PlatformException catch (e) {
      print('Failed to set geofencing locations: ${e.message}');
    }
  }

  Future<void> stopGeofencingLocations() async {
    try {
      await geofencingChannel.invokeMethod(AppConstants.stopGeofencingMethodName);
    } on PlatformException catch (e) {
      print('Failed to stop geofencing locations: ${e.message}');
    }
  }

  void _initEventListener() {
    geofencingEventChannel
      .receiveBroadcastStream()
      .listen((dynamic event){
        if(event is Map){
          final eventType = event['event'] as String?;
          final regionId = event['regionId'] as String?;

          if(eventType == 'onEnterGeofence' && regionId != null) {
            _geofencingEnteredController.add(regionId);
          }
        }
      }, onError: (e) {
        print('Geofencing event error: $e');
    });
  }
}