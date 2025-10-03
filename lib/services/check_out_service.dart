import 'package:mapss/services/attendance_service.dart';

class CheckOutService {
  final AttendanceService _attendanceService = AttendanceService();

  Future<dynamic> clockOut(double latitude, double longitude, String activity, String imagePath) {
    return _attendanceService.clockOut(latitude, longitude, activity, imagePath);
  }
}