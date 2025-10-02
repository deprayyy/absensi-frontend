import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';

import '../profile_screen.dart';
// import 'package:mapss/widgets/widget_utils.dart';

class EmployeeProfileWidget extends StatelessWidget {
  final BoxConstraints constraints;

  const EmployeeProfileWidget({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent.withOpacity(0.8), Colors.purpleAccent.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(constraints.maxWidth * 0.04),
          child: Row(
            children: [
              ZoomIn(
                duration: const Duration(milliseconds: 700),
                child: Container(
                  padding: EdgeInsets.all(constraints.maxWidth * 0.01),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: constraints.maxWidth * 0.08,
                    backgroundImage: const NetworkImage('https://picsum.photos/200/300'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ZoomIn(
                  duration: const Duration(milliseconds: 750),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ade Prayoga Nugraha',
                        style: GoogleFonts.poppins(
                          fontSize: constraints.maxWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'COBOL Developer',
                              style: GoogleFonts.poppins(
                                fontSize: constraints.maxWidth * 0.035,
                                color: Colors.white70,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ZoomIn(
                duration: const Duration(milliseconds: 800),
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: constraints.maxWidth * 0.05,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}