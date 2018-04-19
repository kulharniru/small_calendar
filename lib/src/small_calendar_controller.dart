import 'dart:async';
import 'package:meta/meta.dart';
import 'dart:ui';

import 'package:small_calendar/src/callbacks.dart';

typedef DateTime MonthProvider();

class SmallCalendarController {
  /// Date to show when first creating the [SmallCalendar].
  final DateTime initialDate;

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

  DateTimeCallback _jumpToListener;

  MonthProvider _displayedMonthProvider;

  Set<VoidCallback> _dayRefreshListeners = new Set<VoidCallback>();

  SmallCalendarController._internal({
    @required this.initialDate,
    this.isTodayCallback,
    this.isSelectedCallback,
    this.hasTick1Callback,
    this.hasTick2Callback,
    this.hasTick3Callback,
  }) : assert(initialDate != null);

  factory SmallCalendarController({
    DateTime initialDate,
    IsHasCallback isTodayCallback,
    IsHasCallback isSelectedCallback,
    IsHasCallback hasTick1Callback,
    IsHasCallback hasTick2Callback,
    IsHasCallback hasTick3Callback,
  }) {
    initialDate ??= new DateTime.now();

    // Extracts year, month and day from [initialDate]
    DateTime initDate = new DateTime(
      initialDate.year,
      initialDate.month,
      initialDate.day,
    );

    return new SmallCalendarController._internal(
      initialDate: initDate,
      isTodayCallback: isTodayCallback,
      isSelectedCallback: isSelectedCallback,
      hasTick1Callback: hasTick1Callback,
      hasTick2Callback: hasTick2Callback,
      hasTick3Callback: hasTick3Callback,
    );
  }

  DateTime get displayedMonth {
    if (_displayedMonthProvider == null) {
      return initialDate;
    } else {
      return _displayedMonthProvider();
    }
  }

  // for listeners -------------------------------------------------------------

  // jumpTo

  void setJumpToListener(DateTimeCallback listener) {
    _jumpToListener = listener;
  }

  void removeJumpToListener() {
    _jumpToListener = null;
  }

  void _notifyJumpToListener(DateTime date) {
    if (_jumpToListener != null) {
      _jumpToListener(date);
    }
  }

  // displayed month

  void setDisplayedMonthProvider(MonthProvider provider) {
    _displayedMonthProvider = provider;
  }

  void removeDisplayedMonthProvider() {
    _displayedMonthProvider = null;
  }

  // refresh

  void attachRefreshListener(VoidCallback listener) {
    _dayRefreshListeners.add(listener);
  }

  void detachRefreshListener(VoidCallback listener) {
    _dayRefreshListeners.remove(listener);
  }

  void _notifyRefreshListeners() {
    for (VoidCallback listener in _dayRefreshListeners) {
      if (listener != null) {
        listener();
      }
    }
  }

  // is has --------------------------------------------------------------------

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

  // goTo ----------------------------------------------------------------------

  /// [SmallCalendar] displays month that shows [date].
  ///
  /// If month with specific [date] cannot be displayed, it shows the nearest month.
  void goToDate(DateTime date) {
    _notifyJumpToListener(date);
  }

  /// [SmallCalendar] displays month that shows today's date.
  ///
  /// If month with today's date cannot be displayed, it shows the nearest month.
  void goToToday() {
    goToDate(new DateTime.now());
  }

  // refresh -------------------------------------------------------------------

  /// Notifies all day widgets to refresh their data.
  void refreshDayInformation() {
    _notifyRefreshListeners();
  }
}
