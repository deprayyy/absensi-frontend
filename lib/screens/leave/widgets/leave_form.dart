import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'input_decoration.dart';

class LeaveForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String? leaveType;
  final int? balance;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? duration;
  final String remarks;
  final Function(String?) onLeaveTypeChanged;
  final Function(String?) onBalanceSaved;
  final Function(DateTime?) onStartDateChanged;
  final Function(DateTime?) onEndDateChanged;
  final Function(String?) onRemarksSaved;
  final VoidCallback onSubmit;
  final bool isEditing;
  final bool isSubmitting; // Tambahkan parameter ini

  const LeaveForm({
    super.key,
    required this.formKey,
    this.leaveType,
    this.balance,
    this.startDate,
    this.endDate,
    this.duration,
    this.remarks = '',
    required this.onLeaveTypeChanged,
    required this.onBalanceSaved,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onRemarksSaved,
    required this.onSubmit,
    required this.isEditing,
    this.isSubmitting = false, // Default false
  });

  @override
  State<LeaveForm> createState() => _LeaveFormState();
}

class _LeaveFormState extends State<LeaveForm> {
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? widget.startDate ?? DateTime.now() : widget.endDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blueAccent,
              secondary: Colors.purpleAccent,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (isStart) {
        widget.onStartDateChanged(picked);
      } else if (!isStart && widget.startDate != null && picked.isBefore(widget.startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End date must be after or equal to start date')),
        );
      } else {
        widget.onEndDateChanged(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Form(
              key: widget.formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: widget.leaveType,
                    hint: Text("Select Leave Type", style: GoogleFonts.poppins(color: Colors.white70)),
                    dropdownColor: Colors.white,
                    items: [
                      {'display': 'Cuti Tahunan', 'value': 'tahunan'},
                      {'display': 'Cuti Khusus', 'value': 'khusus'},
                      {'display': 'Lainnya', 'value': 'lainnya'},
                    ].map((item) => DropdownMenuItem(
                      value: item['value'],
                      child: Text(item['display']!, style: GoogleFonts.poppins()),
                    )).toList(),
                    onChanged: widget.onLeaveTypeChanged,
                    validator: (val) => val == null ? "Pilih leave type" : null,
                    decoration: buildInputDecoration("Leave Type", Icons.category),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    initialValue: widget.balance?.toString() ?? '',
                    keyboardType: TextInputType.number,
                    decoration: buildInputDecoration("Balance (sisa cuti)", Icons.account_balance_wallet),
                    onSaved: widget.onBalanceSaved,
                    validator: (val) {
                      if (val == null || val.isEmpty) return "Masukkan balance";
                      final balance = int.tryParse(val);
                      if (balance == null || balance < 0) return "Masukkan angka valid";
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, true),
                          child: InputDecorator(
                            decoration: buildInputDecoration("Start Date", Icons.date_range),
                            child: Text(
                              widget.startDate == null
                                  ? "Select Start Date"
                                  : DateFormat('yyyy-MM-dd').format(widget.startDate!),
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, false),
                          child: InputDecorator(
                            decoration: buildInputDecoration("End Date", Icons.event),
                            child: Text(
                              widget.endDate == null
                                  ? "Select End Date"
                                  : DateFormat('yyyy-MM-dd').format(widget.endDate!),
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  InputDecorator(
                    decoration: buildInputDecoration("Duration", Icons.timelapse),
                    child: Text(
                      widget.duration ?? "Select dates to calculate duration",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    initialValue: widget.remarks,
                    decoration: buildInputDecoration("Remarks", Icons.edit_note),
                    onSaved: widget.onRemarksSaved,
                    validator: (val) => val!.isEmpty ? "Isi remarks" : null,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.purpleAccent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ElevatedButton(
                      onPressed: widget.isSubmitting ? null : widget.onSubmit, // Nonaktifkan saat submitting
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: widget.isSubmitting // Tampilkan loading jika submitting
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        widget.isEditing ? "Update" : "Submit",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
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