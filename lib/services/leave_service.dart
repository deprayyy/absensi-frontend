import 'package:dio/dio.dart';
import '../screens/leave/data_models/leave_record.dart';
import 'api_client.dart';

class LeaveService {
  final Dio dio;

  LeaveService({required this.dio});

  // Ambil daftar cuti
  Future<List<LeaveRecord>> fetchLeaveRequests() async {
    try {
      final response = await dio.get('/leave-requests');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => LeaveRecord.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load leave requests: ${response.data}',
        );
      }
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/leave-requests'),
        error: e.toString(),
      );
    }
  }

  // Ambil saldo cuti (baru ditambahkan)
  Future<int> fetchLeaveBalance() async {
    try {
      final response = await dio.get('/leave-balance');
      if (response.statusCode == 200) {
        return response.data['data']['balance'] ??
            0; // Default 0 jika tidak ada
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load leave balance: ${response.data}',
        );
      }
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/leave-balance'),
        error: e.toString(),
      );
    }
  }

  // Ajukan cuti baru
  Future<LeaveRecord> submitLeaveRequest(LeaveRecord leave) async {
    try {
      final response = await dio.post(
        '/leave-requests',
        data: leave.toJson(),
      );

      if (response.statusCode == 201) {
        return LeaveRecord.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to submit leave request: ${response.data}',
        );
      }
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/leave-requests'),
        error: e.toString(),
      );
    }
  }

  // Perbarui status cuti (untuk admin)
  Future<LeaveRecord> updateLeaveStatus(int id, String status) async {
    try {
      final response = await dio.put(
        '/leave-requests/$id/status',
        data: {'status': status},
      );

      if (response.statusCode == 200) {
        return LeaveRecord.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to update leave status: ${response.data}',
        );
      }
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/leave-requests/$id/status'),
        error: e.toString(),
      );
    }
  }

  // Perbarui cuti (opsional, jika rute PATCH ditambahkan)
  Future<LeaveRecord> updateLeaveRequest(int id, LeaveRecord leave) async {
    try {
      final response = await dio.patch(
        '/leave-requests/$id',
        data: leave.toJson(),
      );

      if (response.statusCode == 200) {
        return LeaveRecord.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to update leave request: ${response.data}',
        );
      }
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/leave-requests/$id'),
        error: e.toString(),
      );
    }
  }
}