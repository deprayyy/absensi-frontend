import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapss/controllers/check_out_controller.dart';
import 'package:mapss/screens/home/check_in/widgets/check_in_button.dart';
import 'package:mapss/screens/home/check_in/widgets/loading_overlay.dart';
import 'package:mapss/screens/home/check_out/widgets/check_out_image_card.dart';
import 'package:mapss/screens/home/check_out/widgets/check_out_notes_card.dart';
import 'package:animate_do/animate_do.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final controller = CheckOutController();

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
                      CheckOutNotesCard(
                        controller: controller.activityController,
                      ),
                      const SizedBox(height: 24),
                      CheckOutImageCard(
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
                        icon: Icons.logout,
                        text: "Clock Out",
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