import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:small_calendar/src/data/all.dart';

import 'pager_position.dart';

typedef void JumpToMonthListener(Month month);

class SmallCalendarPagerController {
  static const _default_initial_page = 100000;
  static const _default_numOf_pages_after_initial_page = 100000;

  SmallCalendarPagerController._internal({
    @required this.initialMonth,
    this.minimumMonth,
    this.maximumMonth,
  })  : assert(initialMonth != null),
        assert((minimumMonth != null)
            ? (minimumMonth.isBefore(initialMonth) ||
                minimumMonth == initialMonth)
            : true),
        assert((maximumMonth != null)
            ? (maximumMonth.isAfter(initialMonth) ||
                maximumMonth == initialMonth)
            : true);

  factory SmallCalendarPagerController({
    DateTime initialMonth,
    DateTime minimumMonth,
    DateTime maximumMonth,
  }) {
    initialMonth ??= new DateTime.now();

    Month initMonth;
    Month minMonth;
    Month maxMonth;

    // converts DateTime-s to Month-s
    initMonth = new Month.fromDateTime(initialMonth);
    if (minimumMonth != null) {
      minMonth = new Month.fromDateTime(minimumMonth);
    }
    if (maximumMonth != null) {
      maxMonth = new Month.fromDateTime(maximumMonth);
    }

    return new SmallCalendarPagerController._internal(
      initialMonth: initMonth,
      minimumMonth: minMonth,
      maximumMonth: maxMonth,
    );
  }

  /// [Month] to show when first creating the [SmallCalendarPager].
  final Month initialMonth;

  final Month minimumMonth;

  final Month maximumMonth;

  PagerPosition _listener;

  DateTime get displayedMonth {
    if (_listener == null) {
      return initialMonth.toDateTime();
    } else {
      return monthOf(_listener.getPage());
    }
  }

  /// Changes which month is displayed in the controlled [SmallCalendarPager].
  void jumpTo(DateTime month) {
    _listener.jumpToPage(
      pageOf(month),
    );
  }

  void attach(PagerPosition listener) {
    _listener = listener;
  }

  void detach() {
    _listener = null;
  }

  int get initialPage {
    if (minimumMonth == null) {
      return _default_initial_page;
    } else {
      return Month.getDifference(minimumMonth, initialMonth);
    }
  }

  int get numOfPages {
    int r = initialPage + 1;
    if (maximumMonth == null) {
      r += _default_numOf_pages_after_initial_page;
    } else {
      r += Month.getDifference(initialMonth, maximumMonth);
    }

    return r;
  }

  DateTime monthOf(int page) {
    if (minimumMonth == null) {
      int distanceFromInitialPage = page - initialPage;

      return initialMonth.add(distanceFromInitialPage).toDateTime();
    } else {
      return minimumMonth.add(page).toDateTime();
    }
  }

  int pageOf(DateTime month) {
    int r;

    Month m = new Month.fromDateTime(month);
    if (m == initialMonth) {
      r = initialPage;
    } else if (minimumMonth == null) {
      r = initialPage + Month.getDifference(initialMonth, m);
    } else {
      r = Month.getDifference(minimumMonth, m);
    }

    if (r < 0) {
      r = 0;
    } else if (r > numOfPages) {
      r = numOfPages - 1;
    }

    return r;
  }
}
