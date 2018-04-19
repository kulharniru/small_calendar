import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:small_calendar/src/callbacks.dart';
import 'package:small_calendar/src/data/all.dart';
import '../style/day_style.dart';

class CalendarDay extends StatelessWidget {
  final DayData dayData;
  final DayStyle style;
  final DateTimeCallback onPressed;

  CalendarDay({
    @required this.style,
    @required this.dayData,
    @required this.onPressed,
  })  : assert(style != null),
        assert(dayData != null),
        assert(onPressed != null),
        super(key: new ObjectKey(dayData.day));

  @override
  Widget build(BuildContext context) {
    VoidCallback onTap;
    if (onPressed != null) {
      onTap = () {
        onPressed(dayData.day.toDateTime());
      };
    }

    List<Widget> mainColumnItems = <Widget>[];

    // text
    mainColumnItems.add(
      new Expanded(
        flex: 3,
        child: _buildDayNumber(context),
      ),
    );

    // ticks
    if (style.showTicks) {
      // text-tick separation
      mainColumnItems.add(
        new Container(height: style.textTickSeparation),
      );
      mainColumnItems.add(
        new Expanded(
          flex: 1,
          child: _buildTicks(context),
        ),
      );
      // ticks
    }

    return new Container(
      margin: style.margin,
      child: new Material(
        color: Colors.transparent,
        child: new InkWell(
          onTap: onTap,
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: mainColumnItems,
          ),
        ),
      ),
    );
  }

  Widget _buildDayNumber(BuildContext context) {
    Color circleColor = Colors.transparent;
    if (dayData.isToday) {
      circleColor = style.todayColor;
    }
    if (dayData.isSelected) {
      circleColor = style.selectedColor;
    }

    return new Container(
      decoration: new BoxDecoration(
        color: circleColor,
        shape: BoxShape.circle,
      ),
      child: new Center(
        child: new ClipRect(
          child: new Text(
            "${dayData.day.day}",
            style: dayData.day.isExtended
                ? style.extendedDayTextStyle
                : style.dayTextStyle,
          ),
        ),
      ),
    );
  }

  Widget _buildTicks(BuildContext context) {
    List<Widget> ticks = <Widget>[];

    // tick1
    if (dayData.hasTick1) {
      ticks.add(
        _buildTick(
          color: style.tick1Color,
        ),
      );
    }

    // tick2
    if (dayData.hasTick2) {
      ticks.add(
        _buildTick(
          color: style.tick2Color,
        ),
      );
    }

    // tick3
    if (dayData.hasTick3) {
      ticks.add(
        _buildTick(
          color: style.tick3Color,
        ),
      );
    }

    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: ticks,
    );
  }

  Widget _buildTick({@required Color color}) {
    return new Expanded(
      child: new Container(
        decoration: new BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
