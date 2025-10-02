import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'package:mapss/screens/permit/widgets/time_row.dart';

import '../data_models/permit_record.dart';

class PermitCard extends StatelessWidget {
  final PermitRecord permit;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PermitCard({
    super.key,
    required this.permit,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: Duration(milliseconds: 100 * index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent.withOpacity(0.7),
            child: const Icon(Icons.event_note, color: Colors.white),
          ),
          title: Text(
            permit.permitType,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📅 ${DateFormat('yyyy-MM-dd').format(permit.startDate)} - ${DateFormat('yyyy-MM-dd').format(permit.endDate)}',
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
              Text(
                '⏰ ${permit.timeFrom.format(context)} - ${permit.timeTo.format(context)}',
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
              Text(
                '📝 ${permit.reason}',
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
              if (permit.attachment != null)
                Text(
                  '📎 ${permit.attachment!.path.split('/').last}',
                  style: GoogleFonts.poppins(color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
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