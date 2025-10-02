import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapss/services/auth_service.dart';
import 'package:mapss/screens/leave/leave_screen.dart';
import '../../services/location_service.dart';
import '../../services/time_service.dart';
import '../../widgets/bottom_navbar.dart';
import 'widgets/attendance_button.dart';
import 'widgets/attendance_status.dart';
import 'widgets/employee_card.dart';
import 'widgets/location_card.dart';
import '../summary/summary_screen.dart';
import '../permit/permit_screen.dart';
import 'widgets/time_card.dart';
import 'widgets/widget_utils.dart';
import '../auth_screen/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late LocationService locationService;
  late TimeService timeService;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    locationService = LocationService();
    timeService = TimeService();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    timeService.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    await locationService.getCurrentLocation();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeTabContent(locationService: locationService, timeService: timeService),
      const SummaryScreen(),
      const PermitScreen(),
      const LeaveScreen(),
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class HomeTabContent extends StatelessWidget {
  final LocationService locationService;
  final TimeService timeService;

  const HomeTabContent({
    super.key,
    required this.locationService,
    required this.timeService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double paddingHorizontal = constraints.maxWidth * 0.05;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header with Logout
                    FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'MAPSS',
                            style: GoogleFonts.poppins(
                              fontSize: constraints.maxWidth * 0.07,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 28),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 8,
                                  backgroundColor: Colors.transparent,
                                  child: FadeInUp(
                                    duration: const Duration(milliseconds: 300),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.blueAccent.withOpacity(0.9),
                                            Colors.purpleAccent.withOpacity(0.9),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ZoomIn(
                                            duration: const Duration(milliseconds: 400),
                                            child: Text(
                                              'Konfirmasi Logout',
                                              style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          ZoomIn(
                                            duration: const Duration(milliseconds: 450),
                                            child: Text(
                                              'Apakah Anda yakin ingin keluar dari aplikasi?',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: Colors.white70,
                                                height: 1.5,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Flexible(
                                                child: ZoomIn(
                                                  duration: const Duration(milliseconds: 500),
                                                  child: buildDialogButton(
                                                    context,
                                                    label: 'Tidak',
                                                    gradientColors: [
                                                      Colors.grey.shade400,
                                                      Colors.grey.shade600,
                                                    ],
                                                    onPressed: () => Navigator.pop(context, false),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: ZoomIn(
                                                  duration: const Duration(milliseconds: 550),
                                                  child: buildDialogButton(
                                                    context,
                                                    label: 'Ya, Logout',
                                                    gradientColors: [
                                                      Colors.red.shade400,
                                                      Colors.red.shade700,
                                                    ],
                                                    onPressed: () => Navigator.pop(context, true),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );

                              if (confirm == true) {
                                await AuthService().logout();
                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                                        (route) => false,
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    EmployeeProfileWidget(constraints: constraints),
                    const SizedBox(height: 24),
                    AttendanceButtonWidget(constraints: constraints),
                    const SizedBox(height: 24),
                    TimeCard(
                      timeService: timeService,
                    ),
                    const SizedBox(height: 24),
                    const LocationCard(),
                    const SizedBox(height: 24),
                    // AttendanceStatusWidget(constraints: constraints),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}