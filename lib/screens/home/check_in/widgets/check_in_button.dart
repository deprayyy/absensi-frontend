import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class CheckInButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool isEnabled;
  final bool isLoading;

  const CheckInButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.isEnabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
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
                    : text == "Ambil Foto"
                    ? [Colors.blueAccent, Colors.purpleAccent]
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
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  text,
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
    );
  }
}