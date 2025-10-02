import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data_models/attendance_record.dart';


class AttendanceCard extends StatelessWidget {
  final AttendanceRecord record;
  final int index;
  final double fontSizeCardTitle;
  final double fontSizeCardText;
  final double fontSizeCardSubText;
  final double cardMaxWidth;
  final bool isToday;

  const AttendanceCard({
    super.key,
    required this.record,
    required this.index,
    required this.fontSizeCardTitle,
    required this.fontSizeCardText,
    required this.fontSizeCardSubText,
    required this.cardMaxWidth,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final isHighlighted = record.remarks == 'On time';
    return FadeInUp(
      duration: Duration(milliseconds: 800 + index * 100),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: cardMaxWidth),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent.withOpacity(0.3),
                      isHighlighted || isToday
                          ? Colors.green.withOpacity(0.2)
                          : Colors.purpleAccent.withOpacity(0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            record.date,
                            style: GoogleFonts.poppins(
                              fontSize: fontSizeCardTitle,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          record.day,
                          style: GoogleFonts.poppins(
                            fontSize: fontSizeCardSubText,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check-in: ${record.checkInTime}',
                      style: GoogleFonts.poppins(
                        fontSize: fontSizeCardText,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Check-out: ${record.checkOutLocation}',
                            style: GoogleFonts.poppins(
                              fontSize: fontSizeCardSubText,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total Hours: ${record.totalHours}h',
                      style: GoogleFonts.poppins(
                        fontSize: fontSizeCardText,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Activity: ${record.activity}',
                      style: GoogleFonts.poppins(
                        fontSize: fontSizeCardText,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Remarks: ${record.remarks}',
                      style: GoogleFonts.poppins(
                        fontSize: fontSizeCardText,
                        fontWeight: FontWeight.w500,
                        color: isHighlighted ? Colors.green : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}