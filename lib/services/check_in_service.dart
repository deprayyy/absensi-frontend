import 'package:mapss/services/attendance_service.dart';

class CheckInService {
  final AttendanceService _attendanceService = AttendanceService();

  Future<dynamic> clockIn(double latitude, double longitude, String imagePath) {
    return _attendanceService.clockIn(latitude, longitude, imagePath);
  }
}