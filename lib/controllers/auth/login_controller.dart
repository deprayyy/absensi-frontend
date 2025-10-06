import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/home/home_screen.dart';
import '../../services/auth_service.dart';
import '../../screens/auth_screen/widgets/show_dialog.dart';

class LoginController with ChangeNotifier {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool obscurePassword = true;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    _setLoading(true);

    try {
      print('Starting login with username: ${usernameController.text.trim()}');
      final response = await AuthService().login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );

      final statusCode = response.statusCode ?? 500;
      final message = response.data['message'] ?? "";

      print('Login response status: $statusCode');
      print('Login response data: ${response.data}');

      if (statusCode == 200 && response.data['data']?['token'] != null) {
        final token = response.data['data']['token'];
        final userData = response.data['data']['user'];
        final prefs = await SharedPreferences.getInstance();
        print('Saving token: $token');
        await prefs.setString('token', token);
        await prefs.setString('user_name', userData['name']); // Simpan nama
        await prefs.setString('user_position', userData['position']); // Simpan posisi

        ModernDialog.show(
          context,
          type: DialogType.success,
          title: "Login Berhasil",
          message: "Selamat, Anda berhasil login!",
          autoClose: true,
          onClose: () {
            print('Navigating to HomeScreen');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          },
        );
      } else {
        print('Invalid response format or authentication failed');
        ModernDialog.show(
          context,
          type: DialogType.error,
          message: "Username atau password salah",
        );
      }
    } catch (e) {
      print('Login error: $e');
      if (e.toString().contains('Invalid username or password')) {
        ModernDialog.show(
          context,
          type: DialogType.error,
          message: "Username atau password salah",
        );
      } else {
        ModernDialog.show(
          context,
          type: DialogType.warning,
          title: "Gangguan Server",
          message: "Tidak dapat terhubung ke server. Periksa koneksi internet Anda lalu coba lagi.",
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}