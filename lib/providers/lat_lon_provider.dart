import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LatLonProvider extends ChangeNotifier {
  double? currentLat;
  double? currentLon;

  getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (kDebugMode) {
        print("Location Denied");
      }

      await Geolocator.requestPermission();
    } else {
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
      Position currentPosition = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);

      currentLat = currentPosition.latitude;
      currentLon = currentPosition.longitude;
      sharedPreferences.setDouble("LAT", currentLat!);
      sharedPreferences.setDouble("LON", currentLon!);
      notifyListeners();
    }
  }
}
