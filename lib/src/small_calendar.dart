import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'data/all.dart';
import 'style_data/all.dart';
import 'widgets/all.dart';
import 'small_calendar_controller.dart';
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

  /// Callback that fires when user selects on a day.
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
  static const _initial_page = 1000000;

  PageController _pageController;

  /// Month that was displayed when widget was first built.
  Month _initialMonth;

  /// List of days to be displayed on weekday indication.
  List<int> _weekdayIndicationDays;

  /// Index of page that is currently being displayed.
  int _currentPage;

  @override
  void initState() {
    super.initState();

    _initPageController();
    _initInitialMonth();
    initWeekdayIndicationDays();

    widget.controller.addGoToDateListener(onGoToDate);
  }

  void _initPageController() {
    _pageController = new PageController(initialPage: _initial_page);
    _currentPage = _initial_page;
  }

  void _initInitialMonth() {
    _initialMonth = new Month.fromDateTime(
      widget.controller.initialDate,
    );
  }

  void initWeekdayIndicationDays() {
    _weekdayIndicationDays = generateWeekdays(widget.firstWeekday);
  }

  @override
  void dispose() {
    widget.controller.removeGoToDateListener(onGoToDate);

    super.dispose();
  }

  @override
  void didUpdateWidget(SmallCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
//
//    if (oldWidget.controller != widget.controller) {
//      oldWidget.controller.removeGoToDateListener(onGoToDate);
//      widget.controller.addGoToDateListener(onGoToDate);
//    }
//
//    bool shouldRefresh = false;
//    if (oldWidget.firstWeekday != widget.firstWeekday) {
//      shouldRefresh = true;
//      initWeekdayIndicationDays();
//    }
////    if (oldWidget.initialDate.year != widget.initialDate.year ||
////        oldWidget.initialDate.month != widget.initialDate.month ||
////        oldWidget.initialDate.day != widget.initialDate.day) {
////      shouldRefresh = true;
////      _initPageController();
////      _initInitialMonth();
////    }
//
//    if (shouldRefresh) {
//      setState(() {});
//    }
  }

  void onPageChanged() {
    int newPage = _pageController.page.toInt();
    if (_currentPage != newPage) {
      _currentPage = newPage;
      callOnDisplayedMonthChangedListener();
    }
  }

  void callOnDisplayedMonthChangedListener() {
    if (widget.onDisplayedMonthChanged != null) {
      Month displayedMonth = _initialMonth.add(
        _currentPage - _initial_page,
      );

      widget.onDisplayedMonthChanged(
        displayedMonth.year,
        displayedMonth.month,
      );
    }
  }

  void onGoToDate(DateTime date) {
    Month desiredMonth = new Month.fromDateTime(date);

    int difference = Month.getDifference(_initialMonth, desiredMonth);
    _pageController.jumpToPage(_initial_page + difference);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new SmallCalendarStyle(
        dayStyleData: widget.dayStyle,
        weekdayIndicationStyleData: widget.weekdayIndicationStyle,
        child: new NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification value) {
            if (value is ScrollEndNotification) {
              onPageChanged();
              return true;
            }
          },
          child: new PageView.builder(
            itemBuilder: _monthCalendarBuilder,
            controller: _pageController,
          ),
        ),
      ),
    );
  }

  Widget _monthCalendarBuilder(BuildContext context, int index) {
    return new MonthCalendar(
      month: _initialMonth.add(index - _initial_page),
      firstWeekday: widget.firstWeekday,
      controller: widget.controller,
      showWeekdayIndication: widget.showWeekdayIndication,
      weekdayIndicationDays: _weekdayIndicationDays,
      dayNames: widget.dayNamesMap,
      weekdayIndicationHeight: widget.weekdayIndicationHeight,
      onDayPressed: widget.onDaySelected,
    );
  }
}
