import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart'; // Assuming you use go_router for navigation

class RegisterController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final posisiController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  final Dio _dio = Dio(); // Configure Dio with base URL, interceptors, etc.
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
    notifyListeners();
  }

  Future<void> register(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.post('/register', data: {
        'name': nameController.text,
        'username': usernameController.text,
        'email': emailController.text,
        'posisi': posisiController.text,
        'password': passwordController.text,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['token'] != null) {
          await _storage.write(key: 'token', value: response.data['token']);
          if (response.data['refresh_token'] != null) {
            await _storage.write(key: 'refresh_token', value: response.data['refresh_token']);
          }
          // Navigate to home screen or login screen
          if (context.mounted) {
            GoRouter.of(context).go('/home'); // Adjust route as needed
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registrasi berhasil!')),
            );
          }
        } else {
          throw Exception('Token tidak ditemukan dalam respons.');
        }
      } else {
        throw Exception('Gagal mendaftar: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      String errorMessage = 'Terjadi kesalahan saat mendaftar.';
      if (e.response != null) {
        if (e.response!.statusCode == 422) {
          final errors = e.response!.data['errors'] ?? {};
          errorMessage = errors.isNotEmpty ? errors.values.join(', ') : 'Validasi gagal.';
        } else {
          errorMessage = _getErrorMessage(e.response!.statusCode);
        }
      } else {
        errorMessage = 'Tidak dapat terhubung ke server.';
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _getErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Data yang dimasukkan tidak valid.';
      case 409:
        return 'Email atau username sudah terdaftar.';
      case 500:
        return 'Terjadi kesalahan pada server.';
      default:
        return 'Terjadi kesalahan tidak diketahui.';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    posisiController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}