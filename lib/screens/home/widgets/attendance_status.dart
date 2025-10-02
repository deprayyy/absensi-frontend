import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widget_utils.dart';

class AttendanceStatusWidget extends StatelessWidget {
  final BoxConstraints constraints;

  const AttendanceStatusWidget({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1400),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(constraints.maxWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status Absensi Hari Ini',
                style: GoogleFonts.poppins(
                  fontSize: constraints.maxWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              buildStatusRow('Clock In:', 'Belum Clock In Hari Ini'),
              const SizedBox(height: 8),
              buildStatusRow('Clock Out:', 'Belum Clock Out Hari Ini'),
              const SizedBox(height: 8),
              buildStatusRow('Status:', 'Belum Clock In', Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}