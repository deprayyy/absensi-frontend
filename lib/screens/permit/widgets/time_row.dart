import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'input_decoration.dart';

class TimeRow extends StatefulWidget {
  final TimeOfDay? timeFrom;
  final TimeOfDay? timeTo;
  final Function(TimeOfDay?) onTimeFromChanged;
  final Function(TimeOfDay?) onTimeToChanged;

  const TimeRow({
    super.key,
    this.timeFrom,
    this.timeTo,
    required this.onTimeFromChanged,
    required this.onTimeToChanged,
  });

  @override
  State<TimeRow> createState() => _TimeRowState();
}

class _TimeRowState extends State<TimeRow> {
  Future<void> _selectTime(BuildContext context, bool isFromTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isFromTime ? widget.timeFrom ?? TimeOfDay.now() : widget.timeTo ?? TimeOfDay.now(),
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
      if (isFromTime) {
        widget.onTimeFromChanged(picked);
      } else {
        widget.onTimeToChanged(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectTime(context, true),
            child: InputDecorator(
              decoration: buildInputDecoration('Time From', Icons.access_time),
              child: Text(
                widget.timeFrom == null ? 'Select Time' : widget.timeFrom!.format(context),
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
              decoration: buildInputDecoration('Time To', Icons.timer),
              child: Text(
                widget.timeTo == null ? 'Select Time' : widget.timeTo!.format(context),
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}