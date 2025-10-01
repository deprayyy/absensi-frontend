import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeService {
  late ValueNotifier<String> currentTime;
  late Timer _timer;

  TimeService() {
    currentTime = ValueNotifier<String>(_formatDateTime(DateTime.now()));
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      currentTime.value = _formatDateTime(DateTime.now());
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss\nEEEE, MMMM d, yyyy').format(dateTime);
  }

  void dispose() {
    _timer.cancel();
    currentTime.dispose();
  }
}