import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'data_models/attendance_record.dart';
import 'widgets/attendance_card.dart';
import 'widgets/fab_button.dart';
import 'widgets/filter_dialogs.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final List<AttendanceRecord> attendanceRecords = [
    AttendanceRecord(
      date: '2025-10-01',
      day: 'Wednesday',
      checkInTime: '08:30 AM',
      checkInLocation: '-6.236364, 106.825571',
      checkOutLocation: '-6.236365, 106.825572',
      totalHours: '8.0',
      activity: 'Daily tasks',
      remarks: 'On time',
    ),
    AttendanceRecord(
      date: '2025-09-30',
      day: 'Tuesday',
      checkInTime: '08:00 AM',
      checkInLocation: '-6.236366, 106.825573',
      checkOutLocation: '-6.236367, 106.825574',
      totalHours: '8.5',
      activity: 'Completed daily tasks',
      remarks: 'On time',
    ),
    AttendanceRecord(
      date: '2025-09-29',
      day: 'Monday',
      checkInTime: '07:45 AM',
      checkInLocation: '-6.236368, 106.825575',
      checkOutLocation: '-6.236369, 106.825576',
      totalHours: '9.0',
      activity: 'Team meeting',
      remarks: 'Early check-in',
    ),
    AttendanceRecord(
      date: '2025-09-28',
      day: 'Sunday',
      checkInTime: '09:00 AM',
      checkInLocation: '-6.236370, 106.825577',
      checkOutLocation: '-6.236371, 106.825578',
      totalHours: '7.5',
      activity: 'Project review',
      remarks: 'Late check-out',
    ),
    AttendanceRecord(
      date: '2025-09-27',
      day: 'Saturday',
      checkInTime: '08:15 AM',
      checkInLocation: '-6.236372, 106.825579',
      checkOutLocation: '-6.236373, 106.825580',
      totalHours: '8.0',
      activity: 'Code review',
      remarks: 'On time',
    ),
    AttendanceRecord(
      date: '2025-09-26',
      day: 'Friday',
      checkInTime: '07:50 AM',
      checkInLocation: '-6.236374, 106.825581',
      checkOutLocation: '-6.236375, 106.825582',
      totalHours: '8.5',
      activity: 'Client call',
      remarks: 'Early check-in',
    ),
  ];

  DateTime? _selectedDate;
  String _searchQuery = '';
  String _filterRemark = 'All';
  bool _isFabExpanded = false;

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2025, 1, 1),
      lastDate: DateTime(2025, 12, 31),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blueAccent,
            colorScheme: const ColorScheme.light(primary: Colors.blueAccent),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
    setState(() => _isFabExpanded = false);
  }

  void _scrollToDate(DateTime date) {
    final index = attendanceRecords.indexWhere((record) {
      return DateTime.parse(record.date).day == date.day &&
          DateTime.parse(record.date).month == date.month &&
          DateTime.parse(record.date).year == date.year;
    });
    if (index != -1) {
      Scrollable.ensureVisible(
        context,
        alignment: 0.5,
        duration: const Duration(milliseconds: 500),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: FadeInUp(
            duration: const Duration(milliseconds: 300),
            child: Text(
              'No record found for ${DateFormat('yyyy-MM-dd').format(date)}',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  List<AttendanceRecord> get _filteredRecords {
    return attendanceRecords.where((record) {
      final dateMatch = _selectedDate == null ||
          DateTime.parse(record.date).day == _selectedDate!.day &&
              DateTime.parse(record.date).month == _selectedDate!.month &&
              DateTime.parse(record.date).year == _selectedDate!.year;
      final searchMatch = _searchQuery.isEmpty ||
          record.remarks.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          record.activity.toLowerCase().contains(_searchQuery.toLowerCase());
      final remarkMatch = _filterRemark == 'All' ||
          (_filterRemark == 'On Time' && record.remarks == 'On time') ||
          (_filterRemark == 'Late' && record.remarks == 'Late check-out');
      return dateMatch && searchMatch && remarkMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final paddingHorizontal = screenWidth * 0.04;
        final fontSizeCardTitle = screenWidth > 600 ? 18.0 : 16.0;
        final fontSizeCardText = screenWidth > 600 ? 16.0 : 14.0;
        final fontSizeCardSubText = screenWidth > 600 ? 14.0 : 12.0;
        final iconSize = screenWidth > 600 ? 35.0 : 30.0;
        final cardMaxWidth = screenWidth > 600 ? 600.0 : double.infinity;
        final fabSize = screenWidth > 400 ? (screenWidth > 600 ? 60.0 : 50.0) : 40.0;
        final maxFabWidth = screenWidth * 0.9 - paddingHorizontal * 2;
        final adjustedFabSize = fabSize > maxFabWidth ? maxFabWidth : fabSize;
        final fabSpacing = screenWidth > 600 ? (screenWidth > 600 ? 16.0 : 12.0) : 8.0;
        final maxFabHeight = screenHeight * 0.3;
        final expandedFabCount = _isFabExpanded ? 3 : 0;
        final totalExpandedHeight = (adjustedFabSize * expandedFabCount) + (fabSpacing * (expandedFabCount - 1));
        final dynamicHeight = totalExpandedHeight > maxFabHeight ? maxFabHeight : totalExpandedHeight;

        return SafeArea(
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () => _scrollToDate(DateTime.now()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Go to Today',
                        style: GoogleFonts.poppins(
                          fontSize: fontSizeCardText,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: 8),
                      itemCount: _filteredRecords.length,
                      itemBuilder: (context, index) {
                        final record = _filteredRecords[index];
                        final isToday = DateTime.parse(record.date).day == DateTime.now().day &&
                            DateTime.parse(record.date).month == DateTime.now().month &&
                            DateTime.parse(record.date).year == DateTime.now().year;
                        return AttendanceCard(
                          record: record,
                          index: index,
                          fontSizeCardTitle: fontSizeCardTitle,
                          fontSizeCardText: fontSizeCardText,
                          fontSizeCardSubText: fontSizeCardSubText,
                          cardMaxWidth: cardMaxWidth,
                          isToday: isToday,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: Padding(
              padding: EdgeInsets.only(right: paddingHorizontal, bottom: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _isFabExpanded ? dynamicHeight : 0.0,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (_isFabExpanded)
                            Padding(
                              padding: EdgeInsets.only(bottom: fabSpacing),
                              child: FabButton(
                                icon: Icons.filter_list,
                                onTap: () {
                                  FilterDialogs.showFilterDialog(context, (value) {
                                    setState(() => _filterRemark = value);
                                  });
                                  setState(() => _isFabExpanded = false);
                                },
                              ),
                            ),
                          if (_isFabExpanded)
                            Padding(
                              padding: EdgeInsets.only(bottom: fabSpacing),
                              child: FabButton(
                                icon: Icons.calendar_today,
                                onTap: _selectDate,
                              ),
                            ),
                          if (_isFabExpanded)
                            Padding(
                              padding: EdgeInsets.only(bottom: fabSpacing),
                              child: FabButton(
                                icon: Icons.search,
                                onTap: () {
                                  FilterDialogs.showSearchDialog(context, (value) {
                                    setState(() => _searchQuery = value.toLowerCase());
                                  });
                                  setState(() => _isFabExpanded = false);
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _isFabExpanded = !_isFabExpanded;
                      });
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 6.0,
                    shape: const CircleBorder(),
                    child: Container(
                      width: adjustedFabSize,
                      height: adjustedFabSize,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.purpleAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return RotationTransition(
                              turns: animation,
                              child: child,
                            );
                          },
                          child: Icon(
                            _isFabExpanded ? Icons.close : Icons.add,
                            key: ValueKey<bool>(_isFabExpanded),
                            color: Colors.white,
                            size: iconSize * 0.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        );
      },
    );
  }
}