import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final List<Map<String, dynamic>> attendanceRecords = [
    {
      'date': '2025-10-01',
      'day': 'Wednesday',
      'checkInTime': '08:30 AM',
      'checkInLocation': '-6.236364, 106.825571',
      'checkOutLocation': '-6.236365, 106.825572',
      'totalHours': '8.0',
      'activity': 'Daily tasks',
      'remarks': 'On time',
    },
    {
      'date': '2025-09-30',
      'day': 'Tuesday',
      'checkInTime': '08:00 AM',
      'checkInLocation': '-6.236366, 106.825573',
      'checkOutLocation': '-6.236367, 106.825574',
      'totalHours': '8.5',
      'activity': 'Completed daily tasks',
      'remarks': 'On time',
    },
    {
      'date': '2025-09-29',
      'day': 'Monday',
      'checkInTime': '07:45 AM',
      'checkInLocation': '-6.236368, 106.825575',
      'checkOutLocation': '-6.236369, 106.825576',
      'totalHours': '9.0',
      'activity': 'Team meeting',
      'remarks': 'Early check-in',
    },
    {
      'date': '2025-09-28',
      'day': 'Sunday',
      'checkInTime': '09:00 AM',
      'checkInLocation': '-6.236370, 106.825577',
      'checkOutLocation': '-6.236371, 106.825578',
      'totalHours': '7.5',
      'activity': 'Project review',
      'remarks': 'Late check-out',
    },
    {
      'date': '2025-09-27',
      'day': 'Saturday',
      'checkInTime': '08:15 AM',
      'checkInLocation': '-6.236372, 106.825579',
      'checkOutLocation': '-6.236373, 106.825580',
      'totalHours': '8.0',
      'activity': 'Code review',
      'remarks': 'On time',
    },
    {
      'date': '2025-09-26',
      'day': 'Friday',
      'checkInTime': '07:50 AM',
      'checkInLocation': '-6.236374, 106.825581',
      'checkOutLocation': '-6.236375, 106.825582',
      'totalHours': '8.5',
      'activity': 'Client call',
      'remarks': 'Early check-in',
    },
  ];

  DateTime? _selectedDate;
  String _searchQuery = '';
  String _filterRemark = 'All'; // Filter state: All, On Time, Late
  bool _isFabExpanded = false; // State to control FAB expansion

  @override
  void initState() {
    super.initState();
    // No initial _selectedDate to show all records by default
  }

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
    setState(() => _isFabExpanded = false); // Collapse FABs after selection
  }

  void _scrollToDate(DateTime date) {
    final index = attendanceRecords.indexWhere((record) {
      return DateTime.parse(record['date']).day == date.day &&
          DateTime.parse(record['date']).month == date.month &&
          DateTime.parse(record['date']).year == date.year;
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
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  List<Map<String, dynamic>> get _filteredRecords {
    return attendanceRecords.where((record) {
      final dateMatch = _selectedDate == null ||
          DateTime.parse(record['date']).day == _selectedDate!.day &&
              DateTime.parse(record['date']).month == _selectedDate!.month &&
              DateTime.parse(record['date']).year == _selectedDate!.year;
      final searchMatch = _searchQuery.isEmpty ||
          record['remarks'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          record['activity'].toLowerCase().contains(_searchQuery.toLowerCase());
      final remarkMatch = _filterRemark == 'All' ||
          (_filterRemark == 'On Time' && record['remarks'] == 'On time') ||
          (_filterRemark == 'Late' && record['remarks'] == 'Late check-out');
      return dateMatch && searchMatch && remarkMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final paddingHorizontal = screenWidth * 0.04; // Reduced to 4% to avoid overflow
        final fontSizeCardTitle = screenWidth > 600 ? 18.0 : 16.0;
        final fontSizeCardText = screenWidth > 600 ? 16.0 : 14.0;
        final fontSizeCardSubText = screenWidth > 600 ? 14.0 : 12.0;
        final iconSize = screenWidth > 600 ? 35.0 : 30.0;
        final cardMaxWidth = screenWidth > 600 ? 600.0 : double.infinity;
        final maxFabWidth = screenWidth * 0.9 - paddingHorizontal * 2; // Max width to stay within screen
        final fabSize = screenWidth > 400 ? (screenWidth > 600 ? 60.0 : 50.0) : 40.0;
        final adjustedFabSize = fabSize > maxFabWidth ? maxFabWidth : fabSize; // Constrain fabSize
        final fabSpacing = screenWidth > 600 ? (screenWidth > 600 ? 16.0 : 12.0) : 8.0;
        final maxFabHeight = screenHeight * 0.3; // Limit to 30% of screen height

        // Calculate dynamic height for expanded FABs
        final expandedFabCount = _isFabExpanded ? 3 : 0; // Filter, Date, Search
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
                        final isToday = DateTime.parse(record['date']).day == DateTime.now().day &&
                            DateTime.parse(record['date']).month == DateTime.now().month &&
                            DateTime.parse(record['date']).year == DateTime.now().year;
                        final isHighlighted = record['remarks'] == 'On time';
                        return FadeInUp(
                          duration: Duration(milliseconds: 800 + index * 100),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: cardMaxWidth),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blueAccent.withOpacity(0.3),
                                          isHighlighted || isToday
                                              ? Colors.green.withOpacity(0.2)
                                              : Colors.purpleAccent.withOpacity(0.3),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                record['date'],
                                                style: GoogleFonts.poppins(
                                                  fontSize: fontSizeCardTitle,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              record['day'],
                                              style: GoogleFonts.poppins(
                                                fontSize: fontSizeCardSubText,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Check-in: ${record['checkInTime']}',
                                          style: GoogleFonts.poppins(
                                            fontSize: fontSizeCardText,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              color: Colors.white70,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                'Check-out: ${record['checkOutLocation']}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: fontSizeCardSubText,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white70,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Total Hours: ${record['totalHours']}h',
                                          style: GoogleFonts.poppins(
                                            fontSize: fontSizeCardText,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Activity: ${record['activity']}',
                                          style: GoogleFonts.poppins(
                                            fontSize: fontSizeCardText,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Remarks: ${record['remarks']}',
                                          style: GoogleFonts.poppins(
                                            fontSize: fontSizeCardText,
                                            fontWeight: FontWeight.w500,
                                            color: isHighlighted ? Colors.green : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                    child: SingleChildScrollView( // ✅ biar ga overflow
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (_isFabExpanded)
                            Padding(
                              padding: EdgeInsets.only(bottom: fabSpacing),
                              child: _buildFabButton(
                                icon: Icons.filter_list,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => SimpleDialog(
                                      title: Text('Filter Records', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                      children: [
                                        SimpleDialogOption(
                                          onPressed: () {
                                            setState(() => _filterRemark = 'All');
                                            Navigator.pop(context);
                                          },
                                          child: Text('All', style: GoogleFonts.poppins()),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            setState(() => _filterRemark = 'On Time');
                                            Navigator.pop(context);
                                          },
                                          child: Text('On Time', style: GoogleFonts.poppins()),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            setState(() => _filterRemark = 'Late');
                                            Navigator.pop(context);
                                          },
                                          child: Text('Late', style: GoogleFonts.poppins()),
                                        ),
                                      ],
                                    ),
                                  );
                                  setState(() => _isFabExpanded = false);
                                },
                              ),
                            ),
                          if (_isFabExpanded)
                            Padding(
                              padding: EdgeInsets.only(bottom: fabSpacing),
                              child: _buildFabButton(
                                icon: Icons.calendar_today,
                                onTap: _selectDate,
                              ),
                            ),
                          if (_isFabExpanded)
                            Padding(
                              padding: EdgeInsets.only(bottom: fabSpacing),
                              child: _buildFabButton(
                                icon: Icons.search,
                                onTap: () {
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
                                        onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Close', style: GoogleFonts.poppins()),
                                        ),
                                      ],
                                    ),
                                  );
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
              backgroundColor: Colors.transparent, // biar gradient keliatan
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
            )
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

Widget _buildFabButton({required IconData icon, required VoidCallback onTap}) {
  return Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Colors.blueAccent, Colors.purpleAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Center(
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    ),
  );
}
