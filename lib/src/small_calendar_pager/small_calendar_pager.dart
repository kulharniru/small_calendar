import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'pager_position.dart';
import 'small_calendar_pager_controller.dart';
import 'typedefs.dart';

class SmallCalendarPager extends StatefulWidget {
  SmallCalendarPager._internal({
    @required this.controller,
    @required this.pageBuilder,
    this.onMonthChanged,
  })  : assert(controller != null),
        assert(pageBuilder != null);

  factory SmallCalendarPager({
    SmallCalendarPagerController controller,
    @required SmallCalendarPageBuilder pageBuilder,
    ValueChanged<DateTime> onMonthChanged,
  }) {
    controller ??= new SmallCalendarPagerController();

    return new SmallCalendarPager._internal(
      controller: controller,
      pageBuilder: pageBuilder,
    );
  }

  /// An object that can be used to control the month displayed in the pager.
  final SmallCalendarPagerController controller;

  /// Function that builds the small calendar widget.
  final SmallCalendarPageBuilder pageBuilder;

  /// Called whenever the displayed month changes.
  final ValueChanged<DateTime> onMonthChanged;

  @override
  _SmallCalendarPagerState createState() => new _SmallCalendarPagerState();
}

class _SmallCalendarPagerState extends State<SmallCalendarPager> {
  PageController _pageController;

  int _displayedPage;

  @override
  void initState() {
    super.initState();

    _pageController = _createPageController();
    widget.controller.attach(_createPagerPosition());
  }

  @override
  void didUpdateWidget(SmallCalendarPager oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.detach();
      widget.controller.attach(_createPagerPosition());
    }
  }

  PageController _createPageController() {
    return new PageController(
      initialPage: widget.controller.initialPage,
    );
  }

  PagerPosition _createPagerPosition() {
    void onJumpToPage(int index) {
      _pageController.jumpToPage(index);
    }

    int onGetPage() {
      return _displayedPage;
    }

    return new PagerPosition(
      jumpToPage: onJumpToPage,
      getPage: onGetPage,
    );
  }

  void _onScrollEnded() {
    int newPage = _pageController.page.toInt();

    if (newPage != _displayedPage) {
      _displayedPage = newPage;

      if (widget.onMonthChanged != null) {
        DateTime displayedMonth = widget.controller.monthOf(_displayedPage);
        widget.onMonthChanged(displayedMonth);
      }
    }
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
        itemCount: widget.controller.numOfPages,
        itemBuilder: (BuildContext context, int index) {
          DateTime month = widget.controller.monthOf(index);

          return widget.pageBuilder(context, month);
        },
      ),
    );
  }
}
