import 'dart:io';
import 'package:flutter/material.dart';

class PermitRecord {
  final String permitType;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay timeFrom;
  final TimeOfDay timeTo;
  final String reason;
  final File? attachment;

  PermitRecord({
    required this.permitType,
    required this.startDate,
    required this.endDate,
    required this.timeFrom,
    required this.timeTo,
    required this.reason,
    this.attachment,
  });

  factory PermitRecord.fromMap(Map<String, dynamic> map) {
    return PermitRecord(
      permitType: map['permitType'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      timeFrom: map['timeFrom'],
      timeTo: map['timeTo'],
      reason: map['reason'],
      attachment: map['attachment'] != null ? File(map['attachment']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'permitType': permitType,
      'startDate': startDate,
      'endDate': endDate,
      'timeFrom': timeFrom,
      'timeTo': timeTo,
      'reason': reason,
      'attachment': attachment?.path,
    };
  }
}