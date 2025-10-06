import 'package:intl/intl.dart';

class LeaveRecord {
  final int id;
  final String leaveType;
  final int balance;
  final DateTime startDate;
  final DateTime endDate;
  final String duration;
  final String remarks;
  final String status;

  LeaveRecord({
    required this.id,
    required this.leaveType,
    required this.balance,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.remarks,
    required this.status,
  });

  factory LeaveRecord.fromJson(Map<String, dynamic> json) {
    final startDate = DateTime.parse(json['start_date']);
    final endDate = DateTime.parse(json['end_date']);
    final duration = '${endDate.difference(startDate).inDays + 1} hari';

    return LeaveRecord(
      id: json['id'],
      leaveType: json['leave_type'] == 'tahunan'
          ? 'Cuti Tahunan'
          : json['leave_type'] == 'khusus'
          ? 'Cuti Khusus'
          : 'Cuti Lainnya',
      balance: json['balance'],
      startDate: startDate,
      endDate: endDate,
      duration: duration,
      remarks: json['remarks'] ?? '',
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leave_type': leaveType == 'Cuti Tahunan'
          ? 'tahunan'
          : leaveType == 'Cuti Khusus'
          ? 'khusus'
          : 'lainnya',
      'balance': balance,
      'start_date': DateFormat('yyyy-MM-dd').format(startDate),
      'end_date': DateFormat('yyyy-MM-dd').format(endDate),
      'remarks': remarks,
    };
  }
}