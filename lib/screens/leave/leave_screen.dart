import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'data_models/leave_record.dart';
import 'widgets/leave_form.dart';
import 'widgets/leave_card.dart';

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
  final List<LeaveRecord> _leaves = [];
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _leaves.addAll([
      LeaveRecord(
        leaveType: 'Cuti Tahunan',
        balance: 10,
        startDate: DateTime(2025, 9, 15),
        endDate: DateTime(2025, 9, 17),
        duration: '3 hari',
        remarks: 'Liburan keluarga',
      ),
      LeaveRecord(
        leaveType: 'Cuti Sakit',
        balance: 7,
        startDate: DateTime(2025, 9, 20),
        endDate: DateTime(2025, 9, 21),
        duration: '2 hari',
        remarks: 'Demam tinggi',
      ),
    ]);
  }

  int get _totalLeave => _leaves.length;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_leaveType != null &&
          _balance != null &&
          _startDate != null &&
          _endDate != null &&
          _duration != null &&
          _remarks.isNotEmpty) {
        final newLeave = LeaveRecord(
          leaveType: _leaveType!,
          balance: _balance!,
          startDate: _startDate!,
          endDate: _endDate!,
          duration: _duration!,
          remarks: _remarks,
        );
        setState(() {
          if (_editingIndex != null) {
            _leaves[_editingIndex!] = newLeave;
            _editingIndex = null;
          } else {
            _leaves.add(newLeave);
          }
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
      _leaveType = leave.leaveType;
      _balance = leave.balance;
      _startDate = leave.startDate;
      _endDate = leave.endDate;
      _duration = leave.duration;
      _remarks = leave.remarks;
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
                LeaveForm(
                  formKey: _formKey,
                  leaveType: _leaveType,
                  balance: _balance,
                  startDate: _startDate,
                  endDate: _endDate,
                  duration: _duration,
                  remarks: _remarks,
                  onLeaveTypeChanged: (val) => setState(() => _leaveType = val),
                  onBalanceSaved: (val) => _balance = int.tryParse(val?.toString() ?? "0"),
                  onStartDateChanged: (val) => setState(() => _startDate = val),
                  onEndDateChanged: (val) => setState(() => _endDate = val),
                  onDurationChanged: (val) => setState(() => _duration = val),
                  onRemarksSaved: (val) => _remarks = val ?? '',
                  onSubmit: _submitForm,
                  isEditing: _editingIndex != null,
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
                    return LeaveCard(
                      leave: _leaves[index],
                      index: index,
                      onEdit: () => _editLeave(index),
                      onDelete: () => _deleteLeave(index),
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
}