import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:small_calendar/src/style_data/all.dart';

class StyleInfo extends InheritedWidget {
  final int firstWeekday;

  final bool showWeekdayIndication;
  final List<int> weekdayIndicationDays;
  final Map<int, String> dayNames;
  final double weekdayIndicationHeight;

  final DayStyleData dayStyleData;
  final WeekdayIndicationStyleData weekdayIndicationStyleData;

  StyleInfo({
    @required this.firstWeekday,
    @required this.showWeekdayIndication,
    @required this.weekdayIndicationDays,
    @required this.dayNames,
    @required this.weekdayIndicationHeight,
    @required this.dayStyleData,
    @required this.weekdayIndicationStyleData,
    @required Widget child,
  })  : assert(firstWeekday != null),
        assert(showWeekdayIndication != null),
        assert(weekdayIndicationDays != null),
        assert(dayNames != null),
        assert(weekdayIndicationHeight != null),
        assert(dayStyleData != null),
        assert(weekdayIndicationStyleData != null),
        super(child: child);

  static StyleInfo of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(StyleInfo);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    if (oldWidget is StyleInfo) {
      return oldWidget.firstWeekday != firstWeekday ||
          oldWidget.showWeekdayIndication != showWeekdayIndication ||
          oldWidget.weekdayIndicationDays != weekdayIndicationDays ||
          oldWidget.dayNames != dayNames ||
          oldWidget.weekdayIndicationHeight != weekdayIndicationHeight ||
          oldWidget.dayStyleData != dayStyleData ||
          oldWidget.weekdayIndicationStyleData != weekdayIndicationStyleData;
    } else {
      return true;
    }
  }
}
