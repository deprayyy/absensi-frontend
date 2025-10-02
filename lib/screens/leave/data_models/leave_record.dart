import 'package:flutter/material.dart';

class LeaveRecord {
  final String leaveType;
  final int balance;
  final DateTime startDate;
  final DateTime endDate;
  final String duration;
  final String remarks;

  LeaveRecord({
    required this.leaveType,
    required this.balance,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.remarks,
  });

  factory LeaveRecord.fromMap(Map<String, dynamic> map) {
    return LeaveRecord(
      leaveType: map['leaveType'],
      balance: map['balance'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      duration: map['duration'],
      remarks: map['remarks'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'leaveType': leaveType,
      'balance': balance,
      'startDate': startDate,
      'endDate': endDate,
      'duration': duration,
      'remarks': remarks,
    };
  }
}