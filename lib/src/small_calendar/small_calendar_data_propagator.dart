import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:small_calendar/src/data/all.dart';

typedef void OnNonExistentDayDataRequired(Day day);

typedef DayData OnGenerateNonExistentDayData(Day day);

class SmallCalendarDataPropagator extends InheritedWidget {
  SmallCalendarDataPropagator({
    @required this.firstWeekday,
    @required this.dayNamesMap,
    @required this.dayToDayDataMap,
    @required this.onNonExistentDayDataRequired,
    @required this.onGenerateNonExistentDayData,
    @required Widget child,
  })  : assert(firstWeekday != null),
        assert(dayNamesMap != null),
        assert(dayToDayDataMap != null),
        assert(onNonExistentDayDataRequired != null),
        assert(onGenerateNonExistentDayData != null),
        super(child: child);

  final int firstWeekday;

  final Map<int, String> dayNamesMap;

  final Map<Day, DayData> dayToDayDataMap;

  final OnNonExistentDayDataRequired onNonExistentDayDataRequired;

  final OnGenerateNonExistentDayData onGenerateNonExistentDayData;

  /// Returns [DayData] for a specified day.
  DayData getDayData(Day day) {
    if (dayToDayDataMap.containsKey(day)) {
      return dayToDayDataMap[day];
    } else {
      onNonExistentDayDataRequired(day);

      return onGenerateNonExistentDayData(day);
    }
  }

  @override
  bool updateShouldNotify(SmallCalendarDataPropagator oldWidget) {
    return firstWeekday != oldWidget.firstWeekday ||
        dayNamesMap != oldWidget.dayNamesMap ||
        dayToDayDataMap != oldWidget.dayToDayDataMap ||
        onNonExistentDayDataRequired !=
            oldWidget.onNonExistentDayDataRequired ||
        onGenerateNonExistentDayData != onGenerateNonExistentDayData;
  }

  static SmallCalendarDataPropagator of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(SmallCalendarDataPropagator);
  }
}
