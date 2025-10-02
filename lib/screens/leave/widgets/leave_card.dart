import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../data_models/leave_record.dart';

class LeaveCard extends StatelessWidget {
  final LeaveRecord leave;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LeaveCard({
    super.key,
    required this.leave,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: 300 + (index * 200)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.purpleAccent.withOpacity(0.7),
            child: const Icon(Icons.beach_access, color: Colors.white),
          ),
          title: Text(
            leave.leaveType,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "📅 ${DateFormat('yyyy-MM-dd').format(leave.startDate)} - ${DateFormat('yyyy-MM-dd').format(leave.endDate)}",
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
              Text(
                "⏱ ${leave.duration}",
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
              Text(
                "📝 ${leave.remarks}",
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
              Text(
                "💼 Balance: ${leave.balance} hari",
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}