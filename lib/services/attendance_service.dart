import 'package:dio/dio.dart';
import 'api_client.dart';

class AttendanceService {
  final Dio dio = apiClient;

  Future<Response> clockIn(double lat, double lon, String photoPath) async {
    final formData = FormData.fromMap({
      "latitude": lat,
      "longitude": lon,
      "photo": await MultipartFile.fromFile(photoPath),
    });

    return await dio.post('/attendance/clock-in', data: formData);
  }

  Future<Response> clockOut(double lat, double lon, String note, String photoPath) async {
    final formData = FormData.fromMap({
      "latitude": lat,
      "longitude": lon,
      "activity_note": note,
      "photo": await MultipartFile.fromFile(photoPath),
    });

    return await dio.post('/attendance/clock-out', data: formData);
  }
}
