import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart'; // ✅ pakai ApiClient yang udah kita buat

class AuthService {
  final Dio _dio = ApiClient().dio;

  /// Login user
  Future<Response> login(String username, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        "username": username,
        "password": password,
      });

      if (response.statusCode == 200 && response.data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
        if (response.data['refresh_token'] != null) {
          await prefs.setString('refresh_token', response.data['refresh_token']);
        }
      }

      return response; // ✅ selalu return response
    } on DioException catch (e) {
      if (e.response != null) {
        // ✅ Server kasih error 400/401/403 → return response
        return e.response!;
      }
      // ❌ Network error → lempar biar controller handle
      throw Exception("Tidak dapat terhubung ke server. Periksa koneksi internet Anda.");
    }
  }

  /// Register user
  Future<Response> register(String name, String email, String username, String password, String posisi) async {
    try {
      final response = await _dio.post('/register', data: {
        "name": name,
        "username": username,
        "email": email,
        "posisi": posisi,
        "password": password,
      });

      if (response.statusCode == 200 && response.data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
        if (response.data['refresh_token'] != null) {
          await prefs.setString('refresh_token', response.data['refresh_token']);
        }
      }

      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      throw Exception("Tidak dapat terhubung ke server.");
    }
  }

  /// Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    await prefs.remove('token');
    await prefs.remove('refresh_token');

    try {
      await _dio.post('/logout',
          options: Options(headers: {"Authorization": "Bearer $token"}));
    } catch (_) {
      // Abaikan kalau token sudah expired
    }
  }
}
