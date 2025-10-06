import 'dart:io';
import 'package:dio/dio.dart';
import 'api_client.dart'; // Pastikan ini sudah set auth interceptor

class AttendanceService {
  final Dio dio = apiClient;

  Future<Response> clockIn(double lat, double lon, String photoPath) async {
    final formData = FormData.fromMap({
      "lat": lat,  // Ubah dari "latitude" ke "lat"
      "lng": lon,  // Ubah dari "longitude" ke "lng"
      "type": "in",  // Tambah type untuk clock-in
      "photo": await MultipartFile.fromFile(photoPath),
    });

    return await dio.post('/attendance/check-in', data: formData);
  }

  Future<Response> clockOut(double lat, double lon, String note, String photoPath) async {
    final formData = FormData.fromMap({
      "lat": lat,  // Ubah ke "lat"
      "lng": lon,  // Ubah ke "lng"
      "type": "out",  // Tambah type untuk clock-out
      "activity_note": note,  // Tetap kirim, tapi handle di backend
      "photo": await MultipartFile.fromFile(photoPath),
    });

    return await dio.post('/attendance/check-out', data: formData);
  }
}