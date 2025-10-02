import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'data_models/permit_record.dart';
import 'widgets/permit_form.dart';
import 'widgets/permit_card.dart';

class PermitScreen extends StatefulWidget {
  const PermitScreen({super.key});

  @override
  State<PermitScreen> createState() => _PermitScreenState();
}

class _PermitScreenState extends State<PermitScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _permitType;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _timeFrom;
  TimeOfDay? _timeTo;
  String _reason = '';
  File? _attachment;
  final List<PermitRecord> _permits = [];
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _permits.addAll([
      PermitRecord(
        permitType: 'Sakit',
        startDate: DateTime(2025, 9, 20),
        endDate: DateTime(2025, 9, 22),
        timeFrom: const TimeOfDay(hour: 8, minute: 0),
        timeTo: const TimeOfDay(hour: 16, minute: 0),
        reason: 'Demam dan flu, butuh istirahat',
        attachment: null,
      ),
      PermitRecord(
        permitType: 'Izin',
        startDate: DateTime(2025, 9, 25),
        endDate: DateTime(2025, 9, 25),
        timeFrom: const TimeOfDay(hour: 10, minute: 0),
        timeTo: const TimeOfDay(hour: 12, minute: 0),
        reason: 'Urusan keluarga mendesak',
        attachment: null,
      ),
    ]);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_permitType != null &&
          _startDate != null &&
          _endDate != null &&
          _timeFrom != null &&
          _timeTo != null &&
          _reason.isNotEmpty) {
        final newPermit = PermitRecord(
          permitType: _permitType!,
          startDate: _startDate!,
          endDate: _endDate!,
          timeFrom: _timeFrom!,
          timeTo: _timeTo!,
          reason: _reason,
          attachment: _attachment,
        );
        setState(() {
          if (_editingIndex != null) {
            _permits[_editingIndex!] = newPermit;
            _editingIndex = null;
          } else {
            _permits.add(newPermit);
          }
          _permitType = null;
          _startDate = null;
          _endDate = null;
          _timeFrom = null;
          _timeTo = null;
          _reason = '';
          _attachment = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_editingIndex != null ? '✅ Permit updated!' : '✅ Permit submitted!'),
          ),
        );
      }
    }
  }

  void _editPermit(int index) {
    final permit = _permits[index];
    setState(() {
      _permitType = permit.permitType;
      _startDate = permit.startDate;
      _endDate = permit.endDate;
      _timeFrom = permit.timeFrom;
      _timeTo = permit.timeTo;
      _reason = permit.reason;
      _attachment = permit.attachment;
      _editingIndex = index;
    });
  }

  void _deletePermit(int index) {
    setState(() {
      _permits.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🗑 Permit deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: FadeInDown(
          child: Text(
            'Permit Request',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
                PermitForm(
                  formKey: _formKey,
                  permitType: _permitType,
                  startDate: _startDate,
                  endDate: _endDate,
                  timeFrom: _timeFrom,
                  timeTo: _timeTo,
                  reason: _reason,
                  attachment: _attachment,
                  onPermitTypeChanged: (val) => setState(() => _permitType = val),
                  onStartDateChanged: (val) => setState(() => _startDate = val),
                  onEndDateChanged: (val) => setState(() => _endDate = val),
                  onTimeFromChanged: (val) => setState(() => _timeFrom = val),
                  onTimeToChanged: (val) => setState(() => _timeTo = val),
                  onReasonSaved: (val) => setState(() => _reason = val ?? ''),
                  onAttachmentChanged: (val) => setState(() => _attachment = val),
                  onSubmit: _submitForm,
                  isEditing: _editingIndex != null,
                ),
                const SizedBox(height: 28),
                FadeInLeft(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Permit History',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _permits.length,
                  itemBuilder: (context, index) {
                    return PermitCard(
                      permit: _permits[index],
                      index: index,
                      onEdit: () => _editPermit(index),
                      onDelete: () => _deletePermit(index),
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