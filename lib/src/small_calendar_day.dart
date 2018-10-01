import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:calendar_views/month_view.dart';

import 'day_style.dart';
import 'tick_data.dart';

class SmallCalendarDay extends StatefulWidget {
  SmallCalendarDay({
    @required this.dayOfMonth,
    @required this.tickData,
    @required this.style,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  })  : assert(dayOfMonth != null),
        assert(tickData != null),
        assert(style != null),
        super(key: new ObjectKey(dayOfMonth));

  final DayOfMonth dayOfMonth;

  final TickData tickData;

  final DayStyle style;

  final VoidCallback onTap;

  final VoidCallback onDoubleTap;

  final VoidCallback onLongPress;

  @override
  State createState() => new _SmallCalendarDayState();
}

class _SmallCalendarDayState extends State<SmallCalendarDay> {
  DayStyle get _style => widget.style;

  String get _dayIndicationText {
    DateTime day = widget.dayOfMonth.day;

    return "${day.day}";
  }

  TextStyle get _indicationTextStyle {
    TextStyle textStyle = Theme.of(context).textTheme.body2;
    textStyle = textStyle.merge(widget.style.indicationTextStyle);

    return textStyle;
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          child: new Column(
            children: <Widget>[
              // indication ----------------------------------------------------
              new Expanded(
                flex: _style.indicationFlex,
                child: new Container(
                  color: _style.indicationBackgroundColor,
                  child: new Stack(
                    children: <Widget>[
                      // indication circle
                      new Container(
                        padding: _style.indicationCirclePadding,
                        child: Container(
                          decoration: new BoxDecoration(
                            color: _style.indicationCircleColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // indication text
                      new Center(
                        child: new Text(
                          _dayIndicationText,
                          maxLines: 1,
                          style: _indicationTextStyle,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // ticks ---------------------------------------------------------
              new Expanded(
                flex: 1,
                child: new Container(
                  color: widget.style.ticksBackgroundColor,
                  child: new Container(
                    margin: new EdgeInsets.symmetric(
                        horizontal: 2.0, vertical: 2.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _buildTicks(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        new Material(
          color: Colors.transparent,
          child: new InkWell(
            onTap: widget.onTap,
            onDoubleTap: widget.onDoubleTap,
            onLongPress: widget.onLongPress,
            splashColor: new Color.fromARGB(20, 255, 0, 0),
            highlightColor: Colors.green,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTicks() {
    List<Widget> ticks = <Widget>[];

    if (widget.tickData.hasTick1) {
      ticks.add(
        _buildTick(color: widget.style.tick1Color),
      );
    }

    if (widget.tickData.hasTick2) {
      if (ticks.isNotEmpty) {
        ticks.add(
          _buildTickSeparator(),
        );
      }

      ticks.add(
        _buildTick(color: widget.style.tick2Color),
      );
    }

    if (widget.tickData.hasTick3) {
      if (ticks.isNotEmpty) {
        ticks.add(
          _buildTickSeparator(),
        );
      }

      ticks.add(
        _buildTick(color: widget.style.tick3Color),
      );
    }

    return ticks;
  }

  Widget _buildTick({
    @required Color color,
  }) {
    return new Expanded(
      child: new Container(
        decoration: new BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildTickSeparator() {
    return new Container(
      width: 2.0,
    );
  }
}
