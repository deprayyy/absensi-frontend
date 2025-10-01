import 'dart:io';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> _permits = [];
  int? _editingIndex;

  @override
  void initState() {
    super.initState();

    // Dummy data awal
    _permits.addAll([
      {
        'permitType': 'Sakit',
        'startDate': DateTime(2025, 9, 20),
        'endDate': DateTime(2025, 9, 22),
        'timeFrom': const TimeOfDay(hour: 8, minute: 0),
        'timeTo': const TimeOfDay(hour: 16, minute: 0),
        'reason': 'Demam dan flu, butuh istirahat',
        'attachment': null,
      },
      {
        'permitType': 'Izin',
        'startDate': DateTime(2025, 9, 25),
        'endDate': DateTime(2025, 9, 25),
        'timeFrom': const TimeOfDay(hour: 10, minute: 0),
        'timeTo': const TimeOfDay(hour: 12, minute: 0),
        'reason': 'Urusan keluarga mendesak',
        'attachment': null,
      },
    ]);
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now(),
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
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isFromTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isFromTime ? _timeFrom ?? TimeOfDay.now() : _timeTo ?? TimeOfDay.now(),
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
        if (isFromTime) {
          _timeFrom = picked;
        } else {
          _timeTo = picked;
        }
      });
    }
  }

  Future<void> _pickAttachment() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _attachment = File(image.path);
      });
    }
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
        setState(() {
          final newPermit = {
            'permitType': _permitType,
            'startDate': _startDate,
            'endDate': _endDate,
            'timeFrom': _timeFrom,
            'timeTo': _timeTo,
            'reason': _reason,
            'attachment': _attachment?.path,
          };

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
      _permitType = permit['permitType'];
      _startDate = permit['startDate'];
      _endDate = permit['endDate'];
      _timeFrom = permit['timeFrom'];
      _timeTo = permit['timeTo'];
      _reason = permit['reason'];
      _attachment = permit['attachment'] != null ? File(permit['attachment']) : null;
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
                // ✨ Animated Form
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              FadeInRight(
                                child: DropdownButtonFormField<String>(
                                  value: _permitType,
                                  hint: Text('Select Permit Type', style: GoogleFonts.poppins(color: Colors.white70)),
                                  dropdownColor: Colors.white,
                                  items: <String>['Sakit', 'Izin', 'Pulang Lebih Awal', 'Lainnya']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: GoogleFonts.poppins(color: Colors.black)),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _permitType = newValue;
                                    });
                                  },
                                  validator: (value) => value == null ? 'Please select a permit type' : null,
                                  decoration: _inputDecoration('Permit Type', Icons.assignment),
                                ),
                              ),
                              const SizedBox(height: 14),
                              FadeInRight(delay: const Duration(milliseconds: 100), child: _dateRow()),
                              const SizedBox(height: 14),
                              FadeInRight(delay: const Duration(milliseconds: 200), child: _timeRow()),
                              const SizedBox(height: 14),
                              FadeInRight(
                                delay: const Duration(milliseconds: 300),
                                child: TextFormField(
                                  initialValue: _reason,
                                  decoration: _inputDecoration('Reason', Icons.edit_note),
                                  onSaved: (value) => _reason = value ?? '',
                                  validator: (value) => value!.isEmpty ? 'Please enter a reason' : null,
                                  maxLines: 3,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 14),
                              FadeInRight(
                                delay: const Duration(milliseconds: 400),
                                child: InkWell(
                                  onTap: _pickAttachment,
                                  child: InputDecorator(
                                    decoration: _inputDecoration('Attachment', Icons.attach_file),
                                    child: Text(
                                      _attachment == null ? 'Select Attachment' : _attachment!.path.split('/').last,
                                      style: GoogleFonts.poppins(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 22),
                              ZoomIn(
                                delay: const Duration(milliseconds: 500),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.blueAccent, Colors.purpleAccent],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.purpleAccent.withOpacity(0.4),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text(
                                      _editingIndex != null ? 'Update' : 'Submit',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
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
                    final permit = _permits[index];
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
                            permit['permitType'] ?? '',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '📅 ${DateFormat('yyyy-MM-dd').format(permit['startDate'])} - ${DateFormat('yyyy-MM-dd').format(permit['endDate'])}',
                                style: GoogleFonts.poppins(color: Colors.white70),
                              ),
                              Text(
                                '⏰ ${permit['timeFrom']?.format(context)} - ${permit['timeTo']?.format(context)}',
                                style: GoogleFonts.poppins(color: Colors.white70),
                              ),
                              Text(
                                '📝 ${permit['reason']}',
                                style: GoogleFonts.poppins(color: Colors.white70),
                              ),
                              if (permit['attachment'] != null)
                                Text(
                                  '📎 ${permit['attachment'].split('/').last}',
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
                                onPressed: () => _editPermit(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () => _deletePermit(index),
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

  Widget _dateRow() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectDate(context, true),
            child: InputDecorator(
              decoration: _inputDecoration('Start Date', Icons.date_range),
              child: Text(
                _startDate == null ? 'Select Start Date' : DateFormat('yyyy-MM-dd').format(_startDate!),
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
              decoration: _inputDecoration('End Date', Icons.event),
              child: Text(
                _endDate == null ? 'Select End Date' : DateFormat('yyyy-MM-dd').format(_endDate!),
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _timeRow() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectTime(context, true),
            child: InputDecorator(
              decoration: _inputDecoration('Time From', Icons.access_time),
              child: Text(
                _timeFrom == null ? 'Select Time' : _timeFrom!.format(context),
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: () => _selectTime(context, false),
            child: InputDecorator(
              decoration: _inputDecoration('Time To', Icons.timer),
              child: Text(
                _timeTo == null ? 'Select Time' : _timeTo!.format(context),
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
