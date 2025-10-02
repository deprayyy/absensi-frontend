import 'package:flutter/material.dart';

class AttendanceRecord {
  final String date;
  final String day;
  final String checkInTime;
  final String checkInLocation;
  final String checkOutLocation;
  final String totalHours;
  final String activity;
  final String remarks;

  AttendanceRecord({
    required this.date,
    required this.day,
    required this.checkInTime,
    required this.checkInLocation,
    required this.checkOutLocation,
    required this.totalHours,
    required this.activity,
    required this.remarks,
  });

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      date: map['date'],
      day: map['day'],
      checkInTime: map['checkInTime'],
      checkInLocation: map['checkInLocation'],
      checkOutLocation: map['checkOutLocation'],
      totalHours: map['totalHours'],
      activity: map['activity'],
      remarks: map['remarks'],
    );
  }
}