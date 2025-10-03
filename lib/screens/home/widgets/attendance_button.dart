import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapss/screens/home/check_in/check_in_screen.dart';
import '../check_out_screen.dart';
import 'widget_utils.dart';

class AttendanceButtonWidget extends StatelessWidget {
  final BoxConstraints constraints;

  const AttendanceButtonWidget({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 900),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: ZoomIn(
              duration: const Duration(milliseconds: 1000),
              child: buildEnhancedButton(
                context,
                icon: Icons.login,
                label: 'Check In',
                gradientColors: [Colors.green.shade400, Colors.green.shade700],
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CheckInScreen()),
                  );
                },
              ),
            ),
          ),
          Flexible(
            child: ZoomIn(
              duration: const Duration(milliseconds: 1100),
              child: buildEnhancedButton(
                context,
                icon: Icons.logout,
                label: 'Check Out',
                gradientColors: [Colors.red.shade400, Colors.red.shade700],
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CheckOutScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}