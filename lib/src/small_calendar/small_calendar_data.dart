import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:small_calendar/src/data/all.dart';

import 'callbacks.dart';
import 'small_calendar_data_propagator.dart';

class SmallCalendarData extends StatefulWidget {
  SmallCalendarData({
    this.firstWeekday = DateTime.monday,
    this.dayNamesMap = oneLetterEnglishDayNames,
    this.isTodayCallback,
    this.isSelectedCallback,
    this.hasTick1Callback,
    this.hasTick2Callback,
    this.hasTick3Callback,
    @required this.child,
  })  : assert(firstWeekday != null),
        assert(dayNamesMap != null) {
    // validates firstWeekday
    if (!(firstWeekday >= DateTime.monday && firstWeekday <= DateTime.sunday)) {
      throw new ArgumentError.value(
        firstWeekday,
        "firstWeekday",
        "\"$firstWeekday\" is not a valid weekday. "
            "firstWeekday should be between ${DateTime.monday} and ${DateTime.sunday} (both inclusive).",
      );
    }

    // validates dayNamesMap (it must contains a keyValue pair for every weekday)
    for (int i = DateTime.monday; i <= DateTime.sunday; i++) {
      if (!dayNamesMap.containsKey(i)) {
        throw new ArgumentError(
          "dayNamesMap shuld contain a key-value pair for every weekday (missing value for weekday: $i).",
        );
      }
    }
  }

  /// First day of the week (Monday-1, Tuesday-2...).
  final int firstWeekday;

  /// Map of <int>weekday and <String>weekdayName value pairs.
  final Map<int, String> dayNamesMap;

  /// Future that returns true if a day is today.
  final IsHasCallback isTodayCallback;

  /// Future that returns true if a day is selected.
  final IsHasCallback isSelectedCallback;

  /// Future that returns true if there is a tick1 associated with a day.
  final IsHasCallback hasTick1Callback;

  /// Future that returns true if there is a tick2 associated with a day.
  final IsHasCallback hasTick2Callback;

  /// Future that returns true if there is a tick3 associated with a day.
  final IsHasCallback hasTick3Callback;

  /// Child of this widget.
  final Widget child;

  @override
  _SmallCalendarDataState createState() => new _SmallCalendarDataState();
}

class _SmallCalendarDataState extends State<SmallCalendarData> {
  /// Map that holds [DayData].
  Map<Day, DayData> _dayToDayDataMap = new Map<Day, DayData>();

  @override
  void didUpdateWidget(SmallCalendarData oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isTodayCallback != oldWidget.isSelectedCallback ||
        widget.isSelectedCallback != oldWidget.isSelectedCallback ||
        widget.hasTick1Callback != oldWidget.hasTick1Callback ||
        widget.hasTick2Callback != oldWidget.hasTick2Callback ||
        widget.hasTick3Callback != oldWidget.hasTick3Callback) {
      _refreshDayToDayDataMap();
    }
  }

  /// Refreshes [DayData] of all [Day]s in [_dayToDayDataMap].
  void _refreshDayToDayDataMap() {
    for (Day day in _dayToDayDataMap.keys) {
      _refreshDayDataOfDay(day);
    }
  }

  /// Refreshes [DayData] of specified [day].
  void _refreshDayDataOfDay(Day day) {
    DateTime date = day.toDateTime();

    Future<bool> defaultIsHas() async {
      return false;
    }

    // prepares all callback required to refresh dayData
    List<Future<bool>> isHasCallbacks = <Future<bool>>[];
    if (widget.isTodayCallback != null) {
      isHasCallbacks.add(widget.isTodayCallback(date));
    } else {
      isHasCallbacks.add(defaultIsHas());
    }

    if (widget.isSelectedCallback != null) {
      isHasCallbacks.add(widget.isSelectedCallback(date));
    } else {
      isHasCallbacks.add(defaultIsHas());
    }

    if (widget.hasTick1Callback != null) {
      isHasCallbacks.add(widget.hasTick1Callback(date));
    } else {
      isHasCallbacks.add(defaultIsHas());
    }

    if (widget.hasTick2Callback != null) {
      isHasCallbacks.add(widget.hasTick2Callback(date));
    } else {
      isHasCallbacks.add(defaultIsHas());
    }

    if (widget.hasTick3Callback != null) {
      isHasCallbacks.add(widget.hasTick3Callback(date));
    } else {
      isHasCallbacks.add(defaultIsHas());
    }

    Future.wait(isHasCallbacks).then(
      (List<bool> isHas) {
        setState(() {
          _dayToDayDataMap[day] = _dayToDayDataMap[day].copyWithIsHasChanged(
            isToday: isHas[0],
            isSelected: isHas[1],
            hasTick1: isHas[2],
            hasTick2: isHas[3],
            hasTick3: isHas[4],
          );
        });
      },
    );
  }

  /// Returns [DayData] for a specified [day].
  ///
  /// If required dayData is not yet generated,
  /// it generates default dayData and start a refresh.
  DayData _onGetDayData(Day day) {
    if (!_dayToDayDataMap.containsKey(day)){
      _dayToDayDataMap[day] = new DayData(day: day, isExtended: false);

      _refreshDayDataOfDay(day);
    }

    return _dayToDayDataMap[day];
  }

  @override
  Widget build(BuildContext context) {
    return new SmallCalendarDataPropagator(
      firstWeekday: widget.firstWeekday,
      dayNamesMap: widget.dayNamesMap,
      dayToDayDataMap: _dayToDayDataMap,
      onGetDayData: _onGetDayData,
      child: widget.child,
    );
  }
}
