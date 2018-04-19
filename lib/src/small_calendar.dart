import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'data/all.dart';
import 'style_data/all.dart';
import 'small_calendar_controller.dart';
import 'widgets/all.dart';
import 'callbacks.dart';
import 'generator.dart';

class SmallCalendar extends StatefulWidget {
  /// First day of the week (Monday-1, Tuesday-2...).
  final int firstWeekday;

  /// Style of day widgets.
  final DayStyleData dayStyle;

  /// If true weekday indication will be shown.
  final bool showWeekdayIndication;

  /// Height of weekday indication area
  final double weekdayIndicationHeight;

  /// Style of weekday indication.
  final WeekdayIndicationStyleData weekdayIndicationStyle;

  /// Map of <int>weekday and <String>weekdayName value pairs.
  final Map<int, String> dayNamesMap;

  /// Controller
  final SmallCalendarController controller;

  /// Callback that fires when user selects a day.
  final DateTimeCallback onDaySelected;

  /// Callback that fires when displayed month is changed
  final YearMonthCallback onDisplayedMonthChanged;

  SmallCalendar._internal({
    @required this.controller,
    @required this.firstWeekday,
    this.dayStyle,
    @required this.showWeekdayIndication,
    @required this.weekdayIndicationHeight,
    this.weekdayIndicationStyle,
    @required this.dayNamesMap,
    this.onDaySelected,
    this.onDisplayedMonthChanged,
  })  : assert(controller != null),
        assert(firstWeekday != null),
        assert(showWeekdayIndication != null),
        assert(weekdayIndicationHeight != null),
        assert((firstWeekday >= DateTime.monday) &&
            (firstWeekday <= DateTime.sunday)),
        assert(dayNamesMap != null);

  factory SmallCalendar({
    SmallCalendarController controller,
    int firstWeekday = DateTime.monday,
    DayStyleData dayStyle,
    bool showWeekdayIndication = true,
    double weekdayIndicationHeight = 25.0,
    WeekdayIndicationStyleData weekdayIndicationStyle,
    Map<int, String> dayNamesMap = oneLetterEnglishDayNames,
    DateTimeCallback onDaySelected,
    YearMonthCallback onDisplayedMonthChanged,
  }) {
    // checks that dayNamesMap contains a keyValue pair for every weekday
    if (showWeekdayIndication) {
      for (int i = DateTime.monday; i <= DateTime.sunday; i++) {
        if (!dayNamesMap.containsKey(i)) {
          throw new ArgumentError(
            "dayNamesMap shuld contain a key-value pair for every weekday (missing value for weekday: $i)",
          );
        }
      }
    }

    return new SmallCalendar._internal(
      firstWeekday: firstWeekday,
      dayStyle: dayStyle,
      showWeekdayIndication: showWeekdayIndication,
      weekdayIndicationHeight: weekdayIndicationHeight,
      weekdayIndicationStyle: weekdayIndicationStyle,
      dayNamesMap: dayNamesMap,
      controller: controller ?? new SmallCalendarController(),
      onDaySelected: onDaySelected,
      onDisplayedMonthChanged: onDisplayedMonthChanged,
    );
  }

  @override
  _SmallCalendarState createState() => new _SmallCalendarState();
}

class _SmallCalendarState extends State<SmallCalendar> {
  /// List of days to be displayed on weekday indication.
  List<int> _weekdayIndicationDays;

  MonthPagerController _monthPagerController;

  @override
  void initState() {
    super.initState();

    _monthPagerController = new MonthPagerController(
      initialMonth: new Month.fromDateTime(widget.controller.initialDate),
    );

    initWeekdayIndicationDays();

    // attaches everything to controller
    widget.controller.setJumpToListener(_jumpToListener);
    widget.controller.setDisplayedMonthProvider(_displayedMonthProvider);
  }

  void initWeekdayIndicationDays() {
    _weekdayIndicationDays = generateWeekdays(widget.firstWeekday);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(SmallCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeJumpToListener();
      widget.controller.setJumpToListener(_jumpToListener);

      oldWidget.controller.removeDisplayedMonthProvider();
      widget.controller.setDisplayedMonthProvider(_displayedMonthProvider);

      _monthPagerController = new MonthPagerController(
        initialMonth: new Month.fromDateTime(widget.controller.initialDate),
      );

      setState(() {

      });
    }
  }

  // Attached items ------------------------------------------------------------

  void _jumpToListener(DateTime date) {
    _monthPagerController.jumpToMonth(
      new Month.fromDateTime(date),
    );
  }

  DateTime _displayedMonthProvider() {
    return _monthPagerController.displayedMonth.toDateTime();
  }

  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new StyleInfo(
        firstWeekday: widget.firstWeekday,
        showWeekdayIndication: widget.showWeekdayIndication,
        weekdayIndicationDays: _weekdayIndicationDays,
        dayNames: widget.dayNamesMap,
        weekdayIndicationHeight: widget.weekdayIndicationHeight,
        dayStyleData: widget.dayStyle ?? new DayStyleData(),
        weekdayIndicationStyleData:
            widget.weekdayIndicationStyle ?? new WeekdayIndicationStyleData(),
        child: new MonthPager(
          controller: _monthPagerController,
          monthPageBuilder: (BuildContext context, Month month) =>
              new MonthCalendar(
                month: month,
                controller: widget.controller,
                onDaySelected: widget.onDaySelected,
              ),
          onMonthChanged: (Month displayedMonth) {
            if (widget.onDisplayedMonthChanged != null) {
              widget.onDisplayedMonthChanged(
                  displayedMonth.year, displayedMonth.month);
            }
          },
        ),
      ),
    );
  }
}
