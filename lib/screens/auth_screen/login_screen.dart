import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mapss/screens/auth_screen/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/auth/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(),
      child: Consumer<LoginController>(
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
                                    Colors.blueAccent.withValues(alpha: 0.6),
                                    Colors.purpleAccent.withValues(alpha: 0.6),
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
                                    const Icon(Icons.location_on_rounded,
                                        size: 60, color: Colors.white),
                                    const SizedBox(height: 16),
                                    Text(
                                      "MAPSS",
                                      style: GoogleFonts.poppins(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Designed by DevPray",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    TextFormField(
                                      controller: controller.usernameController,
                                      style: GoogleFonts.poppins(color: Colors.white),
                                      decoration: _inputDecoration(
                                        label: "Username",
                                        icon: Icons.person_2_outlined,
                                      ),
                                      validator: (value) =>
                                      value!.isEmpty ? "Username tidak boleh kosong" : null,
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: controller.passwordController,
                                      obscureText: controller.obscurePassword,
                                      style: GoogleFonts.poppins(color: Colors.white),
                                      decoration: _inputDecoration(
                                        label: "Password",
                                        icon: Icons.lock_outline,
                                        isPassword: true,
                                        onToggle: controller.togglePasswordVisibility,
                                        obscure: controller.obscurePassword,
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) return "Password tidak boleh kosong";
                                        if (value.length < 6) return "Minimal 6 karakter";
                                        return null;
                                      },
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
                                          : () => controller.login(context),
                                      child: controller.isLoading
                                          ? const CircularProgressIndicator(color: Colors.white)
                                          : Text(
                                        "Login",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                                        );
                                      },
                                      child: Text(
                                        "Belum punya akun? Daftar di sini",
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

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    bool isPassword = false,
    VoidCallback? onToggle,
    bool obscure = false,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      suffixIcon: isPassword
          ? IconButton(
        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70),
        onPressed: onToggle,
      )
          : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.1),
    );
  }
}