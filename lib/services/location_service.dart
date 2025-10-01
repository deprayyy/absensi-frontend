import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService extends ChangeNotifier {
  LocationService() {
    _initLocation(); // ✅ ambil lokasi awal + mulai listen
  }

  double? latitude;
  double? longitude;
  bool isLoading = false;
  bool serviceEnabled = false;
  LocationPermission? permission;

  /// ✅ Init awal (sekali jalan)
  Future<void> _initLocation() async {
    await getCurrentLocation();
    listenToLocation();
  }

  /// ✅ Ambil lokasi sekali
  Future<void> getCurrentLocation() async {
    try {
      isLoading = true;
      notifyListeners();

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (kDebugMode) print("⚠️ Location service OFF");
        isLoading = false;
        notifyListeners();
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (kDebugMode) print("⚠️ Permission DENIED");
          isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (kDebugMode) print("⚠️ Permission DENIED FOREVER");
        isLoading = false;
        notifyListeners();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude = position.latitude;
      longitude = position.longitude;

      if (kDebugMode) {
        print("✅ Lokasi sekali: $latitude, $longitude "
            "(accuracy: ${position.accuracy}m)");
      }
    } catch (e) {
      if (kDebugMode) print("❌ Error ambil lokasi: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Stream lokasi realtime
  void listenToLocation() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // update kalau pindah ≥5 meter
      ),
    ).listen((Position position) {
      latitude = position.latitude;
      longitude = position.longitude;

      if (kDebugMode) {
        print("📡 Update realtime: $latitude, $longitude "
            "(accuracy: ${position.accuracy}m)");
      }

      notifyListeners();
    });
  }

  /// ✅ Utility untuk ngecek apakah koordinat valid
  bool get hasLocation => latitude != null && longitude != null;
}
