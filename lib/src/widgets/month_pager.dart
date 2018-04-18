import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../data/month.dart';

typedef Widget MonthPageBuilder(BuildContext context, Month month);

typedef void JumpToMonthListener(Month month);

class MonthPagerController {
  MonthPagerController({
    @required this.initialMonth,
  }) : assert(initialMonth != null) {
    _notifyThatDisplayedMonthHasChanged(initialMonth);
  }

  /// [Month] to show when first creating the [MonthPager].
  final Month initialMonth;

  JumpToMonthListener _listener;

  Month _currentDisplayedMonth;

  /// The current [Month] displayed in [MonthPager].
  Month get displayedMonth => _currentDisplayedMonth;

  void _notifyThatDisplayedMonthHasChanged(Month month) {
    _currentDisplayedMonth = month;
  }

  void attachJumpToMonthListener(JumpToMonthListener listener) {
    _listener = listener;
  }

  void detachJumpToMonthListener(JumpToMonthListener listener) {
    if (_listener != null && _listener == listener) {
      _listener = null;
    }
  }

  void jumpToMonth(Month month) {
    if (_listener != null) {
      _listener(month);
    }
  }
}

class MonthPager extends StatefulWidget {
  MonthPager({
    @required this.controller,
    @required this.monthPageBuilder,
    @required this.onMonthChanged,
  })  : assert(controller != null),
        assert(monthPageBuilder != null),
        assert(onMonthChanged != null);

  final MonthPagerController controller;

  final MonthPageBuilder monthPageBuilder;

  final ValueChanged<Month> onMonthChanged;

  @override
  _MonthPagerState createState() => new _MonthPagerState();
}

class _MonthPagerState extends State<MonthPager> {
  static const _initial_page = 1000000;

  PageController _pageController;
  int _currentPage;

  @override
  void initState() {
    super.initState();

    _pageController = new PageController(initialPage: _initial_page);
    widget.controller.attachJumpToMonthListener(_onJumpToMonth);
    _currentPage = _initial_page;
  }

  void _onScrollEnded() {
    int newPage = _pageController.page.toInt();

    if (_currentPage != newPage) {
      _currentPage = newPage;

      Month month = _monthFromPage(_currentPage);
      widget.controller._notifyThatDisplayedMonthHasChanged(month);
      widget.onMonthChanged(month);
    }
  }

  void _onJumpToMonth(Month month) {
    int monthsFromInitialMonth =
        Month.getDifference(widget.controller.initialMonth, month);

    _pageController.jumpToPage(_initial_page + monthsFromInitialMonth);
  }

  Month _monthFromPage(int pageIndex) {
    int monthsFromInitialMonth = pageIndex - _initial_page;
    return widget.controller.initialMonth.add(monthsFromInitialMonth);
  }

  @override
  Widget build(BuildContext context) {
    return new NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification value) {
        if (value is ScrollEndNotification) {
          _onScrollEnded();
        }
      },
      child: new PageView.builder(
        controller: _pageController,
        itemBuilder: _pageViewItemBuilder,
      ),
    );
  }

  Widget _pageViewItemBuilder(BuildContext context, int index) {
    Month month = _monthFromPage(index);

    return widget.monthPageBuilder(context, month);
  }
}
