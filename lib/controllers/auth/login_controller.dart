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
      final response = await AuthService().login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );

      final statusCode = response.statusCode ?? 500;
      final message = response.data['message'] ?? "";

      if (statusCode == 200) {
        final token = response.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        ModernDialog.show(
          context,
          type: DialogType.success,
          title: "Login Berhasil",
          autoClose: true,
          onClose: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          },
        );
      } else {
        ModernDialog.show(
          context,
          type: DialogType.error,
          message: message.isNotEmpty
              ? message
              : "Username atau password salah. Coba lagi.",
        );
      }
    } catch (_) {
      ModernDialog.show(
        context,
        type: DialogType.warning,
        title: "Gangguan Server",
        message:
        "Tidak dapat terhubung ke server.\nPeriksa koneksi internet Anda lalu coba lagi.",
      );
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
