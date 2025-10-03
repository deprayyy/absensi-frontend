import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapss/services/attendance_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  File? _image;
  final picker = ImagePicker();
  bool isLoading = false;
  final TextEditingController activityController = TextEditingController();

  Future<bool> _requestCameraPermission() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final status = await Permission.camera.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      if (context.mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: Text(
                'Camera permission is required. Please enable it in app settings.',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            action: SnackBarAction(
              label: 'Settings',
              textColor: Colors.white,
              onPressed: () => openAppSettings(),
            ),
          ),
        );
      }
      return false;
    } else {
      if (context.mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: Text(
                'Camera permission denied. Please allow access to use the camera.',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
      return false;
    }
  }

  Future<void> _pickImage() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final hasPermission = await _requestCameraPermission();
    if (!hasPermission) return;

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null && context.mounted) {
        setState(() => _image = File(pickedFile.path));
      } else if (context.mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: Text(
                'No image selected. Please try again.',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: Text(
                'Error accessing camera: $e',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  Future<void> _submit() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (_image == null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: FadeInUp(
            duration: const Duration(milliseconds: 300),
            child: Text(
              "Silakan ambil foto terlebih dahulu",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (activityController.text.trim().isEmpty) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: FadeInUp(
            duration: const Duration(milliseconds: 300),
            child: Text(
              "Silakan isi catatan aktivitas terlebih dahulu",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await AttendanceService().clockOut(
        -6.236364774146748,
        106.82557096084179,
        activityController.text.trim(),
        _image!.path,
      );

      if (response.statusCode == 200) {
        if (context.mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: FadeInUp(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  "Clock-out berhasil!",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
              backgroundColor: Colors.green.withValues(alpha: 0.9),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          Navigator.pop(context);
        }
      } else {
        final message = response.data is Map && response.data['message'] != null
            ? response.data['message']
            : "Gagal clock-out. Status code: ${response.statusCode}";
        if (context.mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: FadeInUp(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  message,
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
              backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: Text(
                "Error: $e",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (context.mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    activityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Clock Out",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: 24.0,
                ),
                child: FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Notes Card with Frosted Glass Effect
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blueAccent.withValues(alpha: 0.3),
                                  Colors.purpleAccent.withValues(alpha: 0.3),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: FadeInUp(
                              duration: const Duration(milliseconds: 700),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.note_alt_outlined,
                                        color: Colors.white70,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        "Catatan Aktivitas",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: activityController,
                                    maxLines: 6,
                                    minLines: 4,
                                    decoration: InputDecoration(
                                      hintText: "Apa yang kamu kerjakan hari ini? Tulis pencapaianmu...",
                                      hintStyle: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.white70, width: 1),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.white70, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.white, width: 1.5),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withValues(alpha: 0.2),
                                      contentPadding: const EdgeInsets.all(20),
                                    ),
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Image Card with Frosted Glass Effect
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blueAccent.withValues(alpha: 0.3),
                                  Colors.purpleAccent.withValues(alpha: 0.3),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: _image == null
                                ? FadeIn(
                              duration: const Duration(milliseconds: 800),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.withValues(alpha: 0.2),
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 80,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Belum ada foto",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Ambil foto untuk menyelesaikan clock-out",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                                : FadeIn(
                              duration: const Duration(milliseconds: 800),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _image!,
                                      height: 300,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Foto siap untuk clock-out",
                                    style: GoogleFonts.poppins(
                                      color: Colors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Take Photo Button
                      FadeInUp(
                        duration: const Duration(milliseconds: 900),
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            transform: Matrix4.identity()..scale(_image != null ? 1.0 : 0.95),
                            constraints: const BoxConstraints(minWidth: 200),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.blueAccent, Colors.purpleAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.camera_alt, color: Colors.white, size: 24),
                                  const SizedBox(width: 12),
                                  Text(
                                    "Take Photo",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Clock Out Button
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: GestureDetector(
                          onTap: isLoading ? null : _submit,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            transform: Matrix4.identity()..scale(isLoading ? 0.95 : 1.0),
                            constraints: const BoxConstraints(minWidth: 200),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isLoading
                                      ? [Colors.grey.shade400, Colors.grey.shade600]
                                      : [Colors.green.shade400, Colors.green.shade700],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.logout, color: Colors.white, size: 24),
                                  const SizedBox(width: 12),
                                  Text(
                                    "Clock Out",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Loading Overlay
            if (isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: Center(
                  child: ZoomIn(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            color: Colors.blueAccent,
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Processing...",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}