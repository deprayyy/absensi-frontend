import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapss/controllers/check_in_controller.dart';
import 'package:mapss/screens/home/check_in/widgets/check_in_button.dart';
import 'package:mapss/screens/home/check_in/widgets/check_in_image_card.dart';
import 'package:mapss/screens/home/check_in/widgets/loading_overlay.dart';
import 'package:animate_do/animate_do.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final controller = CheckInController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Clock In",
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
                      CheckInImageCard(
                        image: controller.image,
                        onTap: () => controller.pickImage(context),
                      ),
                      const SizedBox(height: 24),
                      CheckInButton(
                        icon: Icons.camera_alt,
                        text: "Ambil Foto",
                        onTap: () => controller.pickImage(context),
                        isEnabled: !controller.isLoading,
                      ),
                      const SizedBox(height: 16),
                      CheckInButton(
                        icon: Icons.login,
                        text: "Clock In",
                        onTap: () => controller.submit(context),
                        isEnabled: !controller.isLoading,
                        isLoading: controller.isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (controller.isLoading) const LoadingOverlay(),
          ],
        ),
      ),
    );
  }
}