import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:small_calendar/src/data/all.dart';

import 'style/all.dart';
import 'calendar_day.dart';
import 'callbacks.dart';
import 'small_calendar_data_propagator.dart';
import 'weekday_indicator.dart';

class SmallCalendar extends StatelessWidget {
  SmallCalendar({
    @required this.month,
    @required this.showWeekdayIndication,
    @required this.weekdayIndicationStyle,
    @required this.dayStyle,
    this.onDaySelected,
  });

  /// Month that is represented in this [SmallCalendar].
  final DateTime month;

  /// If true weekday indication will be shown.
  final bool showWeekdayIndication;

  /// Style of weekday indication.
  final WeekdayIndicationStyle weekdayIndicationStyle;

  /// Style of a day inside this [SmallCalendar].
  final DayStyle dayStyle;

  /// Called whenever user selects a day.
  final DateCallback onDaySelected;

  List<int> _generateWeekdayIndicationDays(BuildContext context) {
    return generateWeekdays(
      SmallCalendarDataPropagator.of(context).firstWeekday,
    );
  }

  List<Day> _generateDaysOfMonth(BuildContext context) {
    return generateDaysOfMonth(
      month,
      SmallCalendarDataPropagator.of(context).firstWeekday,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnItems = <Widget>[];

    if (showWeekdayIndication) {
      columnItems.add(_buildWeekdayIndication(context));
    }

    columnItems.addAll(_buildWeeks(context));

    return new Column(
      children: columnItems,
    );
  }

  Widget _buildWeekdayIndication(BuildContext context) {
    return new Container(
      color: weekdayIndicationStyle.backgroundColor,
      height: weekdayIndicationStyle.weekdayIndicationHeight,
      child: new Row(
        children: _generateWeekdayIndicationDays(context)
            .map<Widget>((weekday) => new Expanded(
                    child: new WeekdayIndicator(
                  text: SmallCalendarDataPropagator
                      .of(context)
                      .dayNamesMap[weekday],
                  weekdayIndicationStyle: weekdayIndicationStyle,
                )))
            .toList(),
      ),
    );
  }

  List<Widget> _buildWeeks(BuildContext context) {
    List<Widget> r = <Widget>[];

    List<Day> daysOfMonth = _generateDaysOfMonth(context);

    for (int i = 0; i < daysOfMonth.length; i += 7) {
      Iterable<Day> daysOfWeek = daysOfMonth.getRange(i, i + 7);
      r.add(
        new Expanded(
          child: _buildWeek(context, daysOfWeek),
        ),
      );
    }

    return r;
  }

  Widget _buildWeek(BuildContext context, Iterable<Day> daysOfWeek) {
    return new Row(
      children: daysOfWeek
          .map((day) => new Expanded(
                child: new CalendarDay(
                  dayData:
                      SmallCalendarDataPropagator.of(context).getDayData(day),
                  isExtended: day.month != month.month,
                  style: dayStyle,
                  onPressed: onDaySelected,
                ),
              ))
          .toList(),
    );
  }
}
