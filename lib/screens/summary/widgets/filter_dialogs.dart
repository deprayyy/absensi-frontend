import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterDialogs {
  static void showFilterDialog(BuildContext context, Function(String) onFilterSelected) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Filter Records', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        children: [
          SimpleDialogOption(
            onPressed: () {
              onFilterSelected('All');
              Navigator.pop(context);
            },
            child: Text('All', style: GoogleFonts.poppins()),
          ),
          SimpleDialogOption(
            onPressed: () {
              onFilterSelected('On Time');
              Navigator.pop(context);
            },
            child: Text('On Time', style: GoogleFonts.poppins()),
          ),
          SimpleDialogOption(
            onPressed: () {
              onFilterSelected('Late');
              Navigator.pop(context);
            },
            child: Text('Late', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  static void showSearchDialog(BuildContext context, Function(String) onSearchChanged) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search Records', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter keyword (e.g., remarks, activity)',
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
          ),
          style: GoogleFonts.poppins(),
          onChanged: onSearchChanged,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }
}