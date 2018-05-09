import 'dart:async';

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

  /// Month that is represented in this [SmallCalendarOLD].
  final DateTime month;

  /// If true weekday indication will be shown.
  final bool showWeekdayIndication;

  /// Style of weekday indication.
  final WeekdayIndicationStyle weekdayIndicationStyle;

  /// Style of a day inside this [SmallCalendarOLD].
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

//class SmallCalendarOLD extends StatefulWidget {
//  /// Creates a new instance of [SmallCalendarOLD].
//  SmallCalendarOLD._internal({
//    @required this.month,
//    @required this.dataProvider,
//    @required this.firstWeekday,
//    @required this.showWeekdayIndication,
//    @required this.dayNamesMap,
//    @required this.dayStyle,
//    @required this.weekdayIndicationStyle,
//    this.onDaySelected,
//  })  : assert(month != null),
//        assert(dataProvider != null),
//        assert(firstWeekday != null),
//        assert(showWeekdayIndication != null),
//        assert(dayNamesMap != null),
//        assert(dayStyle != null),
//        assert(weekdayIndicationStyle != null) {
//    // validates firstWeekday
//    if (!(firstWeekday >= DateTime.monday && firstWeekday <= DateTime.sunday)) {
//      throw new ArgumentError.value(
//        firstWeekday,
//        "firstWeekday",
//        "\"$firstWeekday\" is not a valid weekday. "
//            "firstWeekday should be between ${DateTime.monday} and ${DateTime.sunday} (both inclusive).",
//      );
//    }
//
//    // validates that dayNamesMap contains a keyValue pair for every weekday
//    for (int i = DateTime.monday; i <= DateTime.sunday; i++) {
//      if (!dayNamesMap.containsKey(i)) {
//        throw new ArgumentError(
//          "dayNamesMap shuld contain a key-value pair for every weekday (missing value for weekday: $i).",
//        );
//      }
//    }
//  }
//
//  factory SmallCalendarOLD({
//    @required DateTime month,
//    SmallCalendarDataProvider dataProvider,
//    int firstWeekday = DateTime.monday,
//    bool showWeekdayIndication = true,
//    Map<int, String> dayNamesMap = oneLetterEnglishDayNames,
//    DayStyle dayStyle,
//    WeekdayIndicationStyle weekdayIndicationStyle,
//    DateCallback onDaySelected,
//  }) {
//    dataProvider ??= new SmallCalendarDataProvider();
//
//    dayStyle ??= new DayStyle();
//    weekdayIndicationStyle ??= new WeekdayIndicationStyle();
//
//    return new SmallCalendarOLD._internal(
//      month: month,
//      dataProvider: dataProvider,
//      firstWeekday: firstWeekday,
//      showWeekdayIndication: showWeekdayIndication,
//      dayNamesMap: dayNamesMap,
//      dayStyle: dayStyle,
//      weekdayIndicationStyle: weekdayIndicationStyle,
//      onDaySelected: onDaySelected,
//    );
//  }
//
//  /// Month that is represented in this [SmallCalendarOLD].
//  final DateTime month;
//
//  /// An object that provides day data and can be user to notify the widget to refresh its day data.
//  final SmallCalendarDataProvider dataProvider;
//
//  /// First day of the week (Monday-1, Tuesday-2...).
//  final int firstWeekday;
//
//  /// If true weekday indication will be shown.
//  final bool showWeekdayIndication;
//
//  /// Map of <int>weekday and <String>weekdayName value pairs.
//  final Map<int, String> dayNamesMap;
//
//  /// Style of a day inside this [SmallCalendarOLD].
//  final DayStyle dayStyle;
//
//  /// Style of weekday indication.
//  final WeekdayIndicationStyle weekdayIndicationStyle;
//
//  /// Called whenever user selects a day.
//  final DateCallback onDaySelected;
//
//  @override
//  _SmallCalendarState createState() => new _SmallCalendarState();
//}
//
//class _SmallCalendarState extends State<SmallCalendarOLD> {
//  bool isActive;
//
//  List<int> _weekdayIndicationDays;
//
//  List<DayData> _daysData;
//
//  @override
//  void initState() {
//    super.initState();
//
//    isActive = true;
//
//    widget.dataProvider.attach(_refreshDaysData);
//
//    _weekdayIndicationDays = _generateWeekdayIndicationDays();
//    _daysData = _generateDefaultDaysData();
//    _refreshDaysData();
//  }
//
//  @override
//  void dispose() {
//    isActive = false;
//
//    super.dispose();
//  }
//
//  @override
//  void didUpdateWidget(SmallCalendarOLD oldWidget) {
//    super.didUpdateWidget(oldWidget);
//
//    if (oldWidget.dataProvider != widget.dataProvider) {
//      oldWidget.dataProvider.detach(_refreshDaysData);
//      widget.dataProvider.attach(_refreshDaysData);
//      _refreshDaysData();
//    }
//
//    if (oldWidget.firstWeekday != widget.firstWeekday ||
//        (oldWidget.month.year != widget.month.year ||
//            oldWidget.month.month != widget.month.month)) {
//      setState(() {
//        _weekdayIndicationDays = _generateWeekdayIndicationDays();
//        _daysData = _generateDefaultDaysData();
//        _refreshDaysData();
//      });
//    }
//  }
//
//  List<int> _generateWeekdayIndicationDays() {
//    return generateWeekdays(widget.firstWeekday);
//  }
//
//  List<DayData> _generateDefaultDaysData() {
//    return generateDaysData(widget.month, widget.firstWeekday);
//  }
//
//  Future<Null> _refreshDaysData() async {
//    Future<DayData> refreshDayData(DayData dayData) async {
//      DateTime day = dayData.day;
//
//      return dayData.copyWithIsHasChanged(
//        isToday: await widget.dataProvider.isToday(day),
//        isSelected: await widget.dataProvider.isSelected(day),
//        hasTick1: await widget.dataProvider.hasTick1(day),
//        hasTick2: await widget.dataProvider.hasTick2(day),
//        hasTick3: await widget.dataProvider.hasTick3(day),
//      );
//    }
//
//    for (int i = 0; i < _daysData.length; i++) {
//      refreshDayData(_daysData[i]).then((refreshedDayData) {
//        if (!isActive) return;
//
//        setState(() {
//          _daysData[i] = refreshedDayData;
//        });
//      });
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    List<Widget> columnItems = <Widget>[];
//
//    if (widget.showWeekdayIndication) {
//      columnItems.add(_buildWeekdayIndication(context));
//    }
//
//    columnItems.addAll(_buildWeeks(context));
//
//    return new Column(
//      children: columnItems,
//    );
//  }
//
//  Widget _buildWeekdayIndication(BuildContext context) {
//    return new Container(
//      color: widget.weekdayIndicationStyle.backgroundColor,
//      height: widget.weekdayIndicationStyle.weekdayIndicationHeight,
//      child: new Row(
//        children: _weekdayIndicationDays
//            .map<Widget>((weekday) => new Expanded(
//                    child: new WeekdayIndicator(
//                  text: widget.dayNamesMap[weekday],
//                  weekdayIndicationStyle: widget.weekdayIndicationStyle,
//                )))
//            .toList(),
//      ),
//    );
//  }
//
//  List<Widget> _buildWeeks(BuildContext context) {
//    List<Widget> r = <Widget>[];
//
//    for (int i = 0; i < _daysData.length; i += 7) {
//      Iterable<DayData> daysOfWeek = _daysData.getRange(i, i + 7);
//      r.add(
//        new Expanded(
//          child: _buildWeek(context, daysOfWeek),
//        ),
//      );
//    }
//
//    return r;
//  }
//
//  Widget _buildWeek(BuildContext context, Iterable<DayData> daysOfWeek) {
//    return new Row(
//      children: daysOfWeek
//          .map((dayData) => new Expanded(
//                child: new CalendarDay(
//                  dayData: dayData,
//                  style: widget.dayStyle,
//                  onPressed: widget.onDaySelected,
//                ),
//              ))
//          .toList(),
//    );
//  }
//}
