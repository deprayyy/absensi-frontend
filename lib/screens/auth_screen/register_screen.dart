import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/auth/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterController(),
      child: Consumer<RegisterController>(
        builder: (context, controller, _) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blueAccent.withOpacity(0.6),
                                    Colors.purpleAccent.withOpacity(0.6),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              padding: const EdgeInsets.all(24),
                              child: Form(
                                key: controller.formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.app_registration_rounded,
                                        size: 60, color: Colors.white),
                                    const SizedBox(height: 16),
                                    Text(
                                      "DAFTAR",
                                      style: GoogleFonts.poppins(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Isi model kamu untuk membuat akun",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 32),

                                    _buildInputField(
                                      controller: controller.nameController,
                                      label: "Nama Lengkap",
                                      icon: Icons.person,
                                      registerController: controller,
                                    ),
                                    const SizedBox(height: 16),

                                    _buildInputField(
                                      controller: controller.usernameController,
                                      label: "Username",
                                      icon: Icons.account_circle,
                                      registerController: controller,
                                    ),
                                    const SizedBox(height: 16),

                                    _buildInputField(
                                      controller: controller.emailController,
                                      label: "Email",
                                      icon: Icons.email,
                                      keyboardType: TextInputType.emailAddress,
                                      registerController: controller,
                                    ),
                                    const SizedBox(height: 16),

                                    _buildInputField(
                                      controller: controller.posisiController,
                                      label: "Posisi",
                                      icon: Icons.work,
                                      registerController: controller,
                                    ),
                                    const SizedBox(height: 16),

                                    _buildInputField(
                                      controller: controller.passwordController,
                                      label: "Password",
                                      icon: Icons.lock_outline,
                                      isPassword: true,
                                      obscureText: controller.obscurePassword,
                                      onToggle: controller.togglePasswordVisibility,
                                      registerController: controller,
                                    ),
                                    const SizedBox(height: 16),

                                    _buildInputField(
                                      controller: controller.confirmPasswordController,
                                      label: "Konfirmasi Password",
                                      icon: Icons.lock_outline,
                                      isPassword: true,
                                      obscureText: controller.obscureConfirmPassword,
                                      onToggle: controller.toggleConfirmPasswordVisibility,
                                      registerController: controller,
                                    ),

                                    const SizedBox(height: 32),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        minimumSize: const Size(double.infinity, 50),
                                      ),
                                      onPressed: controller.isLoading
                                          ? null
                                          : () {
                                        if (controller.formKey.currentState!.validate()) {
                                          controller.register(context);
                                        }
                                      },
                                      child: controller.isLoading
                                          ? const CircularProgressIndicator(color: Colors.white)
                                          : Text(
                                        "Daftar",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        "Sudah punya akun? Login",
                                        style: GoogleFonts.poppins(
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.white,
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggle,
    required RegisterController registerController,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: GoogleFonts.poppins(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label tidak boleh kosong";
        }
        if (label == "Email" && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Masukkan email yang valid";
        }
        if (label == "Password" && value.length < 6) {
          return "Password harus minimal 6 karakter";
        }
        if (label == "Konfirmasi Password" &&
            value != registerController.passwordController.text) {
          return "Password tidak cocok";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
          ),
          onPressed: onToggle,
        )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
    );
  }
}
