import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../data/all.dart';
import '../small_calendar_controller.dart';
import '../callbacks.dart';
import '../generator.dart';
import 'style_info.dart';
import 'weekday_indicator.dart';
import 'package:small_calendar/src/small_calendar/calendar_day.dart';

class MonthCalendar extends StatefulWidget {
  final Month month;

  final SmallCalendarController controller;

  final DateTimeCallback onDaySelected;

  MonthCalendar({
    @required this.month,
    @required this.controller,
    @required this.onDaySelected,
  })  : assert(month != null),
        assert(controller != null);

  @override
  _MonthCalendarState createState() => new _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  bool _isActive;
  List<DayData> _days;

  @override
  void initState() {
    super.initState();

    _isActive = true;
    widget.controller.attachRefreshListener(onRefreshDays);
  }

  @override
  void dispose() {
    _isActive = false;
    widget.controller.detachRefreshListener(onRefreshDays);

    super.dispose();
  }

  @override
  void didUpdateWidget(MonthCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.detachRefreshListener(onRefreshDays);
      widget.controller.attachRefreshListener(onRefreshDays);

      // if the controller changes the days should be regenerated
      _days = null;
    }
  }

  void _initDays(int firstWeekday) {
    _days = generateExtendedDaysOfMonth(
      widget.month,
      firstWeekday,
    ).map((day) => new DayData(day: day)).toList();

    _refreshDaysData();
  }

  void onRefreshDays() {
    _refreshDaysData();
  }

  Future _refreshDaysData() async {
    for (int i = 0; i < _days.length; i++) {
      updateIsHasOfDay(_days[i]).then((updatedDay) {
        if (!_isActive) return;
        setState(() {
          _days[i] = updatedDay;
        });
      });
    }
  }

  Future<DayData> updateIsHasOfDay(DayData dayData) async {
    DateTime dateTime = dayData.day.toDateTime();

    return dayData.copyWithIsHasChanged(
      isToday: await widget.controller.isToday(dateTime),
      isSelected: await widget.controller.isSelected(dateTime),
      hasTick1: await widget.controller.hasTick1(dateTime),
      hasTick2: await widget.controller.hasTick2(dateTime),
      hasTick3: await widget.controller.hasTick3(dateTime),
    );
  }

  @override
  Widget build(BuildContext context) {
    StyleInfo styleInfo = StyleInfo.of(context);

    if (_days == null) {
      _initDays(styleInfo.firstWeekday);
    }

    List<Widget> widgets = <Widget>[];

    // builds weekday indication
    if (styleInfo.showWeekdayIndication) {
      widgets.add(
        _buildWeekdayIndication(context, styleInfo),
      );
    }

    // builds weeks
    widgets.addAll(
      _buildWeeks(),
    );

    return new Column(
      mainAxisSize: MainAxisSize.max,
      children: widgets,
    );
  }

  Widget _buildWeekdayIndication(
    BuildContext context,
    StyleInfo styleInfo,
  ) {
    return new Container(
      height: styleInfo.weekdayIndicationHeight,
      color: styleInfo.weekdayIndicationStyleData.backgroundColor,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: styleInfo.weekdayIndicationDays
            .map((day) => new Expanded(
                  child: new WeekdayIndicator(
                    text: "${styleInfo.dayNames[day]}",
                  ),
                ))
            .toList(),
      ),
    );
  }

  List<Widget> _buildWeeks() {
    List<Widget> r = <Widget>[];

    for (int i = 0; i < _days.length; i += 7) {
      Iterable<DayData> daysOfWeek = _days.getRange(i, i + 7);
      r.add(
        _buildWeek(daysOfWeek),
      );
    }

    return r;
  }

  Widget _buildWeek(Iterable<DayData> daysOfWeek) {
    return new Expanded(
      child: new Row(
        children: daysOfWeek
            .map((day) => new Expanded(
                  child: new Day(
                    dayData: day,
                    onPressed: widget.onDaySelected,
                  ),
                ))
            .toList(),
      ),
    );
  }
}
