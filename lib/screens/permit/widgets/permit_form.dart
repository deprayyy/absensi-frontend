import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'input_decoration.dart';
import 'date_row.dart';
import 'time_row.dart';

class PermitForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String? permitType;
  final DateTime? startDate;
  final DateTime? endDate;
  final TimeOfDay? timeFrom;
  final TimeOfDay? timeTo;
  final String reason;
  final File? attachment;
  final Function(String?) onPermitTypeChanged;
  final Function(DateTime?) onStartDateChanged;
  final Function(DateTime?) onEndDateChanged;
  final Function(TimeOfDay?) onTimeFromChanged;
  final Function(TimeOfDay?) onTimeToChanged;
  final Function(String?) onReasonSaved;
  final Function(File?) onAttachmentChanged;
  final VoidCallback onSubmit;
  final bool isEditing;

  const PermitForm({
    super.key,
    required this.formKey,
    this.permitType,
    this.startDate,
    this.endDate,
    this.timeFrom,
    this.timeTo,
    this.reason = '',
    this.attachment,
    required this.onPermitTypeChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onTimeFromChanged,
    required this.onTimeToChanged,
    required this.onReasonSaved,
    required this.onAttachmentChanged,
    required this.onSubmit,
    required this.isEditing,
  });

  @override
  State<PermitForm> createState() => _PermitFormState();
}

class _PermitFormState extends State<PermitForm> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAttachment() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      widget.onAttachmentChanged(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
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
              key: widget.formKey,
              child: Column(
                children: [
                  FadeInRight(
                    child: DropdownButtonFormField<String>(
                      value: widget.permitType,
                      hint: Text('Select Permit Type', style: GoogleFonts.poppins(color: Colors.white70)),
                      dropdownColor: Colors.white,
                      items: <String>['Sakit', 'Izin', 'Pulang Lebih Awal', 'Lainnya']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: GoogleFonts.poppins(color: Colors.black)),
                        );
                      }).toList(),
                      onChanged: widget.onPermitTypeChanged,
                      validator: (value) => value == null ? 'Please select a permit type' : null,
                      decoration: buildInputDecoration('Permit Type', Icons.assignment),
                    ),
                  ),
                  const SizedBox(height: 14),
                  FadeInRight(
                    delay: const Duration(milliseconds: 100),
                    child: DateRow(
                      startDate: widget.startDate,
                      endDate: widget.endDate,
                      onStartDateChanged: widget.onStartDateChanged,
                      onEndDateChanged: widget.onEndDateChanged,
                    ),
                  ),
                  const SizedBox(height: 14),
                  FadeInRight(
                    delay: const Duration(milliseconds: 200),
                    child: TimeRow(
                      timeFrom: widget.timeFrom,
                      timeTo: widget.timeTo,
                      onTimeFromChanged: widget.onTimeFromChanged,
                      onTimeToChanged: widget.onTimeToChanged,
                    ),
                  ),
                  const SizedBox(height: 14),
                  FadeInRight(
                    delay: const Duration(milliseconds: 300),
                    child: TextFormField(
                      initialValue: widget.reason,
                      decoration: buildInputDecoration('Reason', Icons.edit_note),
                      onSaved: widget.onReasonSaved,
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
                        decoration: buildInputDecoration('Attachment', Icons.attach_file),
                        child: Text(
                          widget.attachment == null ? 'Select Attachment' : widget.attachment!.path.split('/').last,
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
                        onPressed: widget.onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          widget.isEditing ? 'Update' : 'Submit',
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
    );
  }
}