import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/time_service.dart';

class TimeCard extends StatefulWidget {
  final TimeService timeService;

  const TimeCard({
    super.key,
    required this.timeService,
  });

  @override
  State<TimeCard> createState() => _TimeCardState();
}

class _TimeCardState extends State<TimeCard> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.9;
    double fontSize = MediaQuery.of(context).size.width * 0.05;

    return FadeInUp(
      duration: const Duration(milliseconds: 1200),
      child: Center(
        child: SizedBox(
          width: cardWidth > 400 ? 400 : cardWidth,
          child: Card(
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            shadowColor: Colors.purple.withOpacity(0.3),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purpleAccent.withOpacity(0.8),
                    Colors.purpleAccent.withOpacity(0.6)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ZoomIn(
                    duration: const Duration(milliseconds: 1300),
                    child: ValueListenableBuilder<String>(
                      valueListenable: widget.timeService.currentTime,
                      builder: (context, currentTime, child) {
                        return Text(
                          currentTime,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}