import 'package:flutter/material.dart';

import 'package:bread_place/ui/common_widgets/primary_button.dart';
import 'package:bread_place/ui/common_widgets/secondary_button.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreenMain extends StatefulWidget {
  const HomeScreenMain({super.key});

  @override
  State<HomeScreenMain> createState() => _HomeScreenMainState();
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  final CameraPosition initialPosition = CameraPosition(
    target: LatLng(37.5214, 126.9246),
    zoom: 15,
  );

  late final GoogleMapController controller;

  checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      throw Exception("위치 기능을 활성화 해주세요.");
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();
    }

    if (checkedPermission != LocationPermission.always &&
        checkedPermission != LocationPermission.whileInUse) {
      throw Exception("위치 권한을 허가해주세요.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkPermission(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          return Column(
            children: [
              Expanded(
                child: GoogleMap(initialCameraPosition: initialPosition,
                    onMapCreated: (GoogleMapController controller) {
                      this.controller = controller;
                    }),
              ),
              const SizedBox(height: 50),
              PrimaryButton(text: 'PrimaryButton', onPressed: () {}),
              const SizedBox(height: 10),
              SecondaryButton(text: 'SecondaryButton', onPressed: () {}),
            ],
          );
        },
      ),
    );
  }
}
