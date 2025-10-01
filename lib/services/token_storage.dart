import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class TokenStorage {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  static Future<void> saveTokens(String token, String? refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    if (refreshToken != null) {
      await prefs.setString('refresh_token', refreshToken);
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refresh_token');
  }

  static Future<bool> tryRefreshToken(Dio dio) async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await dio.post('/refresh', data: {
        "refresh_token": refreshToken,
      });

      if (response.statusCode == 200) {
        await saveTokens(response.data['token'], response.data['refresh_token']);
        return true;
      }
    } catch (_) {}
    return false;
  }
}
