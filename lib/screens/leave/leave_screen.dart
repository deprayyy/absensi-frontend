import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import '../../services/leave_service.dart';
import '../../services/api_client.dart';
import 'data_models/leave_record.dart';
import 'widgets/leave_form.dart';
import 'widgets/leave_card.dart';

class LeaveScreen extends StatefulWidget {
  final bool isAdmin; // Parameter untuk role admin (kirim dari parent)
  const LeaveScreen({super.key, this.isAdmin = false}); // Default false jika tidak dikirim

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _leaveType;
  int? _balance;
  DateTime? _startDate;
  DateTime? _endDate;
  String _remarks = '';
  List<LeaveRecord> _leaves = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  int? _editingIndex;
  late final LeaveService _leaveService;

  @override
  void initState() {
    super.initState();
    _leaveService = LeaveService(dio: apiClient);
    _fetchLeaves();
    _fetchLeaveBalance(); // Panggil untuk ambil saldo (jika endpoint ada)
  }

  // Ambil data cuti dari API
  Future<void> _fetchLeaves() async {
    try {
      setState(() => _isLoading = true);
      final leaves = await _leaveService.fetchLeaveRequests();
      setState(() {
        _leaves = leaves;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load leave requests: ${e.toString()}')),
      );
    }
  }

  // Ambil saldo cuti dari API (sekarang defined di LeaveService)
  Future<void> _fetchLeaveBalance() async {
    try {
      final balance = await _leaveService.fetchLeaveBalance();
      setState(() => _balance = balance);
    } catch (e) {
      // Jika endpoint belum ada, abaikan error atau tampilkan warning
      print('Leave balance endpoint not available: $e'); // Atau comment baris ini sementara
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Failed to load leave balance: ${e.toString()}')),
      // );
    }
  }

  // Submit form ke API
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_leaveType != null &&
          _balance != null &&
          _startDate != null &&
          _endDate != null &&
          _remarks.isNotEmpty) {
        if (_endDate!.isBefore(_startDate!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('End date must be after start date')),
          );
          return;
        }
        final durationDays = _endDate!.difference(_startDate!).inDays + 1;
        if (_balance! < durationDays) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Insufficient leave balance. Required: $durationDays days')),
          );
          return;
        }

        setState(() => _isSubmitting = true);
        try {
          final duration = '$durationDays hari';
          final leave = LeaveRecord(
            id: _editingIndex != null ? _leaves[_editingIndex!].id : 0,
            leaveType: _leaveType!,
            balance: _balance!,
            startDate: _startDate!,
            endDate: _endDate!,
            duration: duration,
            remarks: _remarks,
            status: 'pending',
          );

          final response = _editingIndex != null
              ? await _leaveService.updateLeaveRequest(leave.id, leave)
              : await _leaveService.submitLeaveRequest(leave);

          setState(() {
            if (_editingIndex != null) {
              _leaves[_editingIndex!] = response;
              _editingIndex = null;
            } else {
              _leaves.add(response);
            }
            _leaveType = null;
            _balance = null;
            _startDate = null;
            _endDate = null;
            _remarks = '';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_editingIndex != null ? "✅ Leave updated!" : "✅ Leave submitted!")),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        } finally {
          if (mounted) {
            setState(() => _isSubmitting = false);
          }
        }
      }
    }
  }

  // Edit cuti
  void _editLeave(int index) {
    final leave = _leaves[index];
    setState(() {
      _leaveType = leave.leaveType;
      _balance = leave.balance;
      _startDate = leave.startDate;
      _endDate = leave.endDate;
      _remarks = leave.remarks;
      _editingIndex = index;
    });
  }

  // Ubah status cuti (untuk admin)
// In LeaveScreen.dart
  Future<void> _updateLeaveStatus(int index, String? status) async {
    if (status == null) return; // Handle null case
    try {
      final updatedLeave = await _leaveService.updateLeaveStatus(_leaves[index].id, status);
      setState(() {
        _leaves[index] = updatedLeave;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Status updated to $status")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: ${e.toString()}')),
      );
    }
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchLeaves,
            tooltip: 'Refresh',
          ),
        ],
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
          child: RefreshIndicator(
            onRefresh: _fetchLeaves,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), // Agar RefreshIndicator bekerja
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  LeaveForm(
                    formKey: _formKey,
                    leaveType: _leaveType,
                    balance: _balance,
                    startDate: _startDate,
                    endDate: _endDate,
                    duration: _endDate != null && _startDate != null
                        ? '${_endDate!.difference(_startDate!).inDays + 1} hari'
                        : null,
                    remarks: _remarks,
                    onLeaveTypeChanged: (val) => setState(() => _leaveType = val),
                    onBalanceSaved: (val) => setState(() => _balance = int.tryParse(val ?? '0')),
                    onStartDateChanged: (val) => setState(() => _startDate = val),
                    onEndDateChanged: (val) => setState(() => _endDate = val),
                    onRemarksSaved: (val) => setState(() => _remarks = val ?? ''),
                    onSubmit: _submitForm,
                    isEditing: _editingIndex != null,
                    isSubmitting: _isSubmitting, // Sekarang defined
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Leave History (Total: ${_leaves.length})",
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
                      return FadeInUp(
                        duration: Duration(milliseconds: 300 + (index * 200)),
                        child: LeaveCard(
                          leave: _leaves[index],
                          index: index,
                          onStatusChanged: widget.isAdmin
                              ? (status) => _updateLeaveStatus(index, status)
                              : null,
                        ),
                      );
                    },
                  ),                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}