import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart'; // ✅ pakai ApiClient yang udah kita buat

class AuthService {
  final Dio _dio = ApiClient().dio;

  /// Login user
  Future<Response> login(String username, String password) async {
    try {
      print('Attempting login with username: $username');
      final response = await _dio.post('/login', data: {
        "username": username,
        "password": password,
      });

      print('Login response status: ${response.statusCode}');
      print('Login response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data['data']?['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          final token = response.data['data']['token'];
          print('Saving token: $token');
          await prefs.setString('token', token);
          if (response.data['data']['refresh_token'] != null) {
            print('Saving refresh_token: ${response.data['data']['refresh_token']}');
            await prefs.setString('refresh_token', response.data['data']['refresh_token']);
          }
          return response;
        } else {
          throw Exception('Invalid response format: Token not found.');
        }
      } else if (response.statusCode == 401) {
        final message = response.data['message'] ?? 'Invalid username or password';
        throw Exception(message);
      } else {
        throw Exception('Unexpected server response: ${response.data['message'] ?? 'Unknown error'}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.response?.statusCode} ${e.response?.data}');
      if (e.response != null) {
        if (e.response!.statusCode == 422) {
          final errors = e.response!.data['errors'] ?? e.response!.data['message'] ?? 'Validation failed';
          throw Exception('Login failed: $errors');
        } else if (e.response!.statusCode == 401) {
          final message = e.response!.data['message'] ?? 'Invalid username or password';
          throw Exception(message);
        } else if (e.response!.statusCode == 500) {
          throw Exception('Server error: ${e.response!.data['message'] ?? 'Unknown server error'}');
        }
        throw Exception('Unexpected error: ${e.response!.data['message'] ?? 'Unknown error'}');
      }
      throw Exception('Failed to connect to server. Please check your internet connection.');
    } catch (e) {
      print('Unexpected error in AuthService: $e');
      throw Exception('Login failed: $e');
    }
  }

  /// Register user
  Future<Response> register(String name, String email, String username, String password, String? posisi) async {
    try {
      print('Attempting registration with username: $username');
      final response = await _dio.post('/register', data: {
        "name": name,
        "email": email,
        "username": username,
        "password": password,
        if (posisi != null) "position": posisi, // Sesuaikan dengan key di AuthController
      });

      print('Register response status: ${response.statusCode}');
      print('Register response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data['data']?['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          final token = response.data['data']['token'];
          print('Saving token: $token');
          await prefs.setString('token', token);
          if (response.data['data']['refresh_token'] != null) {
            print('Saving refresh_token: ${response.data['data']['refresh_token']}');
            await prefs.setString('refresh_token', response.data['data']['refresh_token']);
          }
          return response;
        } else {
          throw Exception('Invalid response format: Token not found.');
        }
      } else if (response.statusCode == 422) {
        final errors = response.data['errors'] ?? response.data['message'] ?? 'Validation failed';
        throw Exception('Registration failed: $errors');
      } else if (response.statusCode == 500) {
        throw Exception('Server error: ${response.data['message'] ?? 'Unknown server error'}');
      } else {
        throw Exception('Unexpected server response: ${response.data['message'] ?? 'Unknown error'}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.response?.statusCode} ${e.response?.data}');
      if (e.response != null) {
        if (e.response!.statusCode == 422) {
          final errors = e.response!.data['errors'] ?? e.response!.data['message'] ?? 'Validation failed';
          throw Exception('Registration failed: $errors');
        } else if (e.response!.statusCode == 500) {
          throw Exception('Server error: ${e.response!.data['message'] ?? 'Unknown server error'}');
        }
        throw Exception('Unexpected error: ${e.response!.data['message'] ?? 'Unknown error'}');
      }
      throw Exception('Failed to connect to server.');
    } catch (e) {
      print('Unexpected error in AuthService: $e');
      throw Exception('Registration failed: $e');
    }
  }

  /// Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    await prefs.remove('token');
    await prefs.remove('refresh_token');

    try {
      print('Attempting logout with token: $token');
      await _dio.post('/logout', options: Options(headers: {"Authorization": "Bearer $token"}));
      print('Logout successful');
    } catch (e) {
      print('Logout error: $e');
      // Abaikan kalau token sudah expired atau server tidak respons
    }
  }
}