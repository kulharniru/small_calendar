import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../style/all.dart';
import '../callbacks.dart';

class SmallCalendarController {
  /// Future that returns true if specific date is today.
  final IsHasCallback isTodayCallback;

  /// Future that returns true if specific date is selected.
  final IsHasCallback isSelectedCallback;

  /// Future that returns true if there is a tick1 associated with specific date.
  final IsHasCallback hasTick1Callback;

  /// Future that returns true if there is a tick2 associated with specific date.
  final IsHasCallback hasTick2Callback;

  /// Future that returns true if there is a tick3 associated with specific date.
  final IsHasCallback hasTick3Callback;

  Set<VoidCallback> _refreshListeners = new Set();

  Future<bool> isToday(DateTime date) async {
    if (isTodayCallback != null) {
      return isTodayCallback(date);
    }

    // default
    DateTime now = new DateTime.now();
    return (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day);
  }

  Future<bool> isSelected(DateTime date) async {
    if (isSelectedCallback != null) {
      return isSelectedCallback(date);
    }

    // default
    return false;
  }

  Future<bool> hasTick1(DateTime date) async {
    if (hasTick1Callback != null) {
      return hasTick1Callback(date);
    }

    // default
    return false;
  }

  Future<bool> hasTick2(DateTime date) async {
    if (hasTick2Callback != null) {
      return hasTick2Callback(date);
    }

    // default
    return false;
  }

  Future<bool> hasTick3(DateTime date) async {
    if (hasTick3Callback != null) {
      return hasTick3Callback(date);
    }

    // default
    return false;
  }

  void refreshDayData() {
    for (VoidCallback _listener in _refreshListeners) {
      _listener();
    }
  }

  void attach(VoidCallback refreshListener) {
    _refreshListeners.add(refreshListener);
  }

  void detach(VoidCallback refreshListener) {
    _refreshListeners.remove(refreshListener);
  }
}

class SmallCalendar extends StatefulWidget {
  /// First day of the week (Monday-1, Tuesday-2...).
  final int firstWeekday;

  /// If true weekday indication will be shown.
  final bool showWeekdayIndication;

  /// Map of <int>weekday and <String>weekdayName value pairs.
  final Map<int, String> dayNamesMap;

  /// Style of day widgets.
  final DayStyle dayStyle;

  /// Style of weekday indication.
  final WeekdayIndicationStyle weekdayIndicationStyle;

  /// Callback that fires when user selects a day.
  final DateCallback onDaySelected;

  @override
  _SmallCalendarState createState() => new _SmallCalendarState();
}

class _SmallCalendarState extends State<SmallCalendar> {
  @override
  Widget build(BuildContext context) {}
}
