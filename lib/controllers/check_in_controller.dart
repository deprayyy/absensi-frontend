import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapss/services/check_in_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInController with ChangeNotifier {
  File? _image;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  File? get image => _image;
  bool get isLoading => _isLoading;

  Future<bool> _requestCameraPermission(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final status = await Permission.camera.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: FadeInUp(
            duration: const Duration(milliseconds: 300),
            child: Text(
              'Izin kamera diperlukan. Silakan aktifkan di pengaturan aplikasi.',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          action: SnackBarAction(
            label: 'Pengaturan',
            textColor: Colors.white,
            onPressed: () => openAppSettings(),
          ),
        ),
      );
      return false;
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: FadeInUp(
            duration: const Duration(milliseconds: 300),
            child: Text(
              'Izin kamera ditolak. Silakan izinkan akses untuk menggunakan kamera.',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return false;
    }
  }

  Future<void> pickImage(BuildContext context) async {
    final hasPermission = await _requestCameraPermission(context);
    if (!hasPermission) return;

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: Text(
                'Tidak ada foto yang dipilih. Silakan coba lagi.',
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: FadeInUp(
            duration: const Duration(milliseconds: 300),
            child: Text(
              'Error saat mengakses kamera: $e',
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

  Future<void> submit(BuildContext context) async {
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

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await CheckInService().clockIn(
        -6.236364774146748,
        106.82557096084179,
        _image!.path,
      );

      if (response.statusCode == 200) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: Text(
                "Clock-in berhasil!",
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
      } else {
        final message = response.data is Map && response.data['message'] != null
            ? response.data['message']
            : "Gagal clock-in. Status code: ${response.statusCode}";
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
    } catch (e) {
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
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}