import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _leaveType;
  int? _balance;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _duration;
  String _remarks = '';

  final List<Map<String, dynamic>> _leaves = [];
  int? _editingIndex;

  @override
  void initState() {
    super.initState();

    // Tambahin dummy data
    _leaves.addAll([
      {
        'leaveType': 'Cuti Tahunan',
        'balance': 10,
        'startDate': DateTime(2025, 9, 15),
        'endDate': DateTime(2025, 9, 17),
        'duration': '3 hari',
        'remarks': 'Liburan keluarga',
      },
      {
        'leaveType': 'Cuti Sakit',
        'balance': 7,
        'startDate': DateTime(2025, 9, 20),
        'endDate': DateTime(2025, 9, 21),
        'duration': '2 hari',
        'remarks': 'Demam tinggi',
      },
    ]);
  }

  int get _totalLeave => _leaves.length;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now(),
      firstDate: DateTime(2025, 1, 1),
      lastDate: DateTime(2026, 12, 31),
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
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_leaveType != null &&
          _balance != null &&
          _startDate != null &&
          _endDate != null &&
          _duration != null &&
          _remarks.isNotEmpty) {
        final newLeave = {
          'leaveType': _leaveType,
          'balance': _balance,
          'startDate': _startDate,
          'endDate': _endDate,
          'duration': _duration,
          'remarks': _remarks,
        };

        setState(() {
          if (_editingIndex != null) {
            _leaves[_editingIndex!] = newLeave;
            _editingIndex = null;
          } else {
            _leaves.add(newLeave);
          }

          // reset form
          _leaveType = null;
          _balance = null;
          _startDate = null;
          _endDate = null;
          _duration = null;
          _remarks = '';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Leave submitted/updated!")),
        );
      }
    }
  }

  void _editLeave(int index) {
    final leave = _leaves[index];
    setState(() {
      _leaveType = leave['leaveType'];
      _balance = leave['balance'];
      _startDate = leave['startDate'];
      _endDate = leave['endDate'];
      _duration = leave['duration'];
      _remarks = leave['remarks'];
      _editingIndex = index;
    });
  }

  void _deleteLeave(int index) {
    setState(() {
      _leaves.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🗑 Leave deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Leave Request",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child: _buildForm(),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Leave History (Total: $_totalLeave)",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _leaves.length,
                  itemBuilder: (context, index) {
                    final leave = _leaves[index];
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
                            leave['leaveType'] ?? '',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "📅 ${DateFormat('yyyy-MM-dd').format(leave['startDate'])} - ${DateFormat('yyyy-MM-dd').format(leave['endDate'])}",
                                style: GoogleFonts.poppins(color: Colors.white70),
                              ),
                              Text(
                                "⏱ ${leave['duration']}",
                                style: GoogleFonts.poppins(color: Colors.white70),
                              ),
                              Text(
                                "📝 ${leave['remarks']}",
                                style: GoogleFonts.poppins(color: Colors.white70),
                              ),
                              Text(
                                "💼 Balance: ${leave['balance']} hari",
                                style: GoogleFonts.poppins(color: Colors.white70),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.white),
                                onPressed: () => _editLeave(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () => _deleteLeave(index),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return ClipRRect(
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
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _leaveType,
                  hint: Text("Select Leave Type", style: GoogleFonts.poppins(color: Colors.white70)),
                  dropdownColor: Colors.white,
                  items: ["Cuti Tahunan", "Cuti Sakit", "Cuti Khusus", "Lainnya"]
                      .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                      .toList(),
                  onChanged: (val) => setState(() => _leaveType = val),
                  validator: (val) => val == null ? "Pilih leave type" : null,
                  decoration: _inputDecoration("Leave Type", Icons.category),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  initialValue: _balance?.toString() ?? '',
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration("Balance (sisa cuti)", Icons.account_balance_wallet),
                  onSaved: (val) => _balance = int.tryParse(val ?? "0"),
                  validator: (val) => val!.isEmpty ? "Masukkan balance" : null,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, true),
                        child: InputDecorator(
                          decoration: _inputDecoration("Start Date", Icons.date_range),
                          child: Text(
                            _startDate == null ? "Select Start Date" : DateFormat('yyyy-MM-dd').format(_startDate!),
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
                          decoration: _inputDecoration("End Date", Icons.event),
                          child: Text(
                            _endDate == null ? "Select End Date" : DateFormat('yyyy-MM-dd').format(_endDate!),
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _duration,
                  hint: Text("Select Duration", style: GoogleFonts.poppins(color: Colors.white70)),
                  dropdownColor: Colors.white,
                  items: ["0.5 hari", "1 hari", "2 hari", "3 hari", "5 hari"]
                      .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                      .toList(),
                  onChanged: (val) => setState(() => _duration = val),
                  validator: (val) => val == null ? "Pilih durasi" : null,
                  decoration: _inputDecoration("Duration Leave", Icons.timelapse),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  initialValue: _remarks,
                  decoration: _inputDecoration("Remarks", Icons.edit_note),
                  onSaved: (val) => _remarks = val ?? '',
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
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      _editingIndex != null ? "Update" : "Submit",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.white70),
      labelStyle: GoogleFonts.poppins(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.25)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 1.6),
      ),
    );
  }
}
