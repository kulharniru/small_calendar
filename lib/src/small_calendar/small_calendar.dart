import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:small_calendar/src/data/all.dart';

import 'style/all.dart';
import 'callbacks.dart';
import 'small_calendar_data_provider.dart';
import 'weekday_indicator.dart';

class SmallCalendar extends StatefulWidget {
  SmallCalendar._internal({
    @required this.dataProvider,
    @required this.firstWeekday,
    @required this.showWeekdayIndication,
    @required this.showTicks,
    @required this.dayNamesMap,
    @required this.dayStyle,
    @required this.weekdayIndicationStyle,
    this.onDaySelected,
  })  : assert(dataProvider != null),
        assert(firstWeekday != null),
        assert(showWeekdayIndication != null),
        assert(showTicks != null),
        assert(dayNamesMap != null),
        assert(dayStyle != null),
        assert(weekdayIndicationStyle != null) {
    // validates [firstWeekday]
    if (!(firstWeekday >= DateTime.monday && firstWeekday <= DateTime.sunday)) {
      throw new ArgumentError.value(
        firstWeekday,
        "firstWeekday",
        "\"$firstWeekday\" is not a valid weekday. "
            "Weekday should be between ${DateTime.monday} and ${DateTime.sunday} (both inclusive).",
      );
    }

    // validates that dayNamesMap contains a keyValue pair for every weekday
    for (int i = DateTime.monday; i <= DateTime.sunday; i++) {
      if (!dayNamesMap.containsKey(i)) {
        throw new ArgumentError(
          "dayNamesMap shuld contain a key-value pair for every weekday (missing value for weekday: $i).",
        );
      }
    }
  }

  factory SmallCalendar({
    SmallCalendarDataProvider dataProvider,
    int firstWeekday = DateTime.monday,
    bool showWeekdayIndication = true,
    bool showTicks = true,
    Map<int, String> dayNamesMap = oneLetterEnglishDayNames,
    DayStyle dayStyle,
    WeekdayIndicationStyle weekdayIndicationStyle,
    DateCallback onDaySelected,
  }) {
    dataProvider ??= new SmallCalendarDataProvider();

    dayStyle ??= new DayStyle();
    weekdayIndicationStyle ??= new WeekdayIndicationStyle();

    return new SmallCalendar._internal(
      dataProvider: dataProvider,
      firstWeekday: firstWeekday,
      showWeekdayIndication: showWeekdayIndication,
      showTicks: showTicks,
      dayNamesMap: dayNamesMap,
      dayStyle: dayStyle,
      weekdayIndicationStyle: weekdayIndicationStyle,
      onDaySelected: onDaySelected,
    );
  }

  /// An object that provides IsHas information
  /// and can be user to notify the widget to refresh its day data.
  final SmallCalendarDataProvider dataProvider;

  /// First day of the week (Monday-1, Tuesday-2...).
  final int firstWeekday;

  /// If true weekday indication will be shown.
  final bool showWeekdayIndication;

  /// If true ticks will be shown.
  final bool showTicks;

  /// Map of <int>weekday and <String>weekdayName value pairs.
  final Map<int, String> dayNamesMap;

  /// Style of a day inside this [SmallCalendar].
  final DayStyle dayStyle;

  /// Style of weekday indication.
  final WeekdayIndicationStyle weekdayIndicationStyle;

  /// Called whenever user selects a day.
  final DateCallback onDaySelected;

  @override
  _SmallCalendarState createState() => new _SmallCalendarState();
}

class _SmallCalendarState extends State<SmallCalendar> {
  List<int> _weekdayIndicationDays;

  @override
  void initState() {
    super.initState();

    widget.dataProvider.attach(_onRefresh);

    _weekdayIndicationDays = _generateWeekdayIndicationDays();
  }

  @override
  void didUpdateWidget(SmallCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.dataProvider != widget.dataProvider) {
      oldWidget.dataProvider.detach(_onRefresh);
      widget.dataProvider.attach(_onRefresh);
    }

    if (oldWidget.firstWeekday != widget.firstWeekday) {
      setState(() {
        _weekdayIndicationDays = _generateWeekdayIndicationDays();
      });
    }
  }

  List<int> _generateWeekdayIndicationDays() {
    return generateWeekdays(widget.firstWeekday);
  }

  void _onRefresh() {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnItems = <Widget>[];

    if (widget.showWeekdayIndication) {
      columnItems.add(_buildWeekdayIndication(context));
    }

    return new ClipRect(
      child: new Column(
        children: columnItems,
      ),
    );
  }

  Widget _buildWeekdayIndication(BuildContext context) {
    return new Container(
      color: widget.weekdayIndicationStyle.backgroundColor,
      height: widget.weekdayIndicationStyle.weekdayIndicationHeight,
      child: new Row(
        children: _weekdayIndicationDays
            .map<Widget>((weekday) => new Expanded(
                    child: new WeekdayIndicator(
                  text: widget.dayNamesMap[weekday],
                  weekdayIndicationStyle: widget.weekdayIndicationStyle,
                )))
            .toList(),
      ),
    );
  }
}
