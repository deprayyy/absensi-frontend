import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../data_models/leave_record.dart';

class LeaveCard extends StatelessWidget {
  final LeaveRecord leave;
  final int index;
  final ValueChanged<String?>? onStatusChanged;

  const LeaveCard({
    super.key,
    required this.leave,
    required this.index,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = leave.status == 'approved'
        ? Colors.green
        : leave.status == 'rejected'
        ? Colors.red
        : Colors.orange;

    // Responsive sizing based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalMargin = screenWidth < 360 ? 4.0 : 8.0;
    final fontSize = screenWidth < 360 ? 11.0 : 12.0;

    return Container(
      margin: EdgeInsets.only(bottom: 12, left: horizontalMargin, right: horizontalMargin),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: screenWidth - (horizontalMargin * 2)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leading avatar
              CircleAvatar(
                radius: screenWidth < 360 ? 16 : 18,
                backgroundColor: Colors.purpleAccent.withOpacity(0.7),
                child: Icon(Icons.beach_access, color: Colors.white, size: fontSize + 4),
              ),
              const SizedBox(width: 8),
              // Main content (title and subtitle)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            leave.leaveType.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: fontSize,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        if (onStatusChanged != null)
                          DropdownButton<String>(
                            value: leave.status,
                            dropdownColor: Colors.white,
                            underline: const SizedBox(),
                            items: ['pending', 'approved', 'rejected']
                                .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(
                                status.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  color: status == 'approved'
                                      ? Colors.green
                                      : status == 'rejected'
                                      ? Colors.red
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize - 1,
                                ),
                              ),
                            ))
                                .toList(),
                            onChanged: onStatusChanged,
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              leave.status.toUpperCase(),
                              style: GoogleFonts.poppins(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize - 1,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "📅 ${DateFormat('yyyy-MM-dd').format(leave.startDate)} - ${DateFormat('yyyy-MM-dd').format(leave.endDate)}",
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: fontSize),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      "⏱ ${leave.duration}",
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: fontSize),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      "📝 ${leave.remarks}",
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: fontSize),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Text(
                      "💼 Balance: ${leave.balance} hari",
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: fontSize),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}