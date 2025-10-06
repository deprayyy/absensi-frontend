import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../profile_screen.dart';

class EmployeeProfileWidget extends StatelessWidget {
  final BoxConstraints constraints;

  const EmployeeProfileWidget({super.key, required this.constraints});

  Future<Map<String, String>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('user_name') ?? 'Unknown User',
      'position': prefs.getString('user_position') ?? 'Unknown Position',
    };
  }

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: FutureBuilder<Map<String, String>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Card(
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
                              snapshot.data?['name'] ?? 'Loading...',
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
                                    snapshot.data?['position'] ?? 'Loading...',
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
            );
          }
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
                          backgroundImage: const AssetImage('assets/profile.jpeg'),
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
                              snapshot.data?['name'] ?? 'Unknown User',
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
                                    snapshot.data?['position'] ?? 'Unknown Position',
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
        },
      ),
    );
  }
}