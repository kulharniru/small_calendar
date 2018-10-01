import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:small_calendar/small_calendar.dart';
import 'package:calendar_views/month_view.dart';

class SmallCalendarDayExample extends StatefulWidget {
  @override
  State createState() => new _SmallCalendarDayExampleState();
}

class _SmallCalendarDayExampleState extends State<SmallCalendarDayExample> {
  double _widthFactor;
  double _heightFactor;

  TickData _tickData;

  @override
  void initState() {
    super.initState();

    _widthFactor = 0.1;
    _heightFactor = 0.1;

    _tickData = new TickData();
  }

  double _calculateWidth(double maxWidth) {
    return maxWidth * _widthFactor;
  }

  double _calculateHeight(double maxHeight) {
    return maxHeight * _heightFactor;
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        duration: new Duration(seconds: 1),
        content: new Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("SmallCallendarDay example"),
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new LayoutBuilder(
              builder: (context, constraints) {
                return new Center(
                  child: new AnimatedContainer(
                    width: _calculateWidth(constraints.maxWidth),
                    height: _calculateHeight(constraints.maxHeight),
                    duration: Duration.zero,
                    child: new SmallCalendarDay(
                      dayOfMonth: new DayOfMonth(
                        day: new DateTime(2018, 10, 12),
                        month: new DateTime(2018, 10, 1),
                      ),
                      tickData: _tickData,
                      onTap: () {
                        _showSnackBar(context, "Tap");
                      },
                      onDoubleTap: (){
                        _showSnackBar(context, "Double Tap");
                      },
                      onLongPress: (){
                        _showSnackBar(context, "Long Press");
                      },
                      style: new DayStyle(
                        indicationBackgroundColor: Colors.grey[200],
                        indicationCircleColor: Colors.purple[200],
                        ticksBackgroundColor: Colors.grey[300],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          new Container(
            color: Colors.grey,
            height: 2.0,
          ),
          new ListTile(
            leading: new Row(
              children: <Widget>[
                new Text("Width:"),
                new Expanded(
                  child: new Slider(
                    value: _widthFactor,
                    onChanged: (value) {
                      setState(() {
                        _widthFactor = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          new ListTile(
            leading: new Row(
              children: <Widget>[
                new Text("Height:"),
                new Expanded(
                  child: new Slider(
                    value: _heightFactor,
                    onChanged: (value) {
                      setState(() {
                        _heightFactor = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          new ListTile(
            leading: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Checkbox(
                  value: _tickData.hasTick1,
                  onChanged: (value) {
                    setState(() {
                      _tickData = _tickData.copyWith(hasTick1: value);
                    });
                  },
                ),
                new Checkbox(
                  value: _tickData.hasTick2,
                  onChanged: (value) {
                    setState(() {
                      _tickData = _tickData.copyWith(hasTick2: value);
                    });
                  },
                ),
                new Checkbox(
                  value: _tickData.hasTick3,
                  onChanged: (value) {
                    setState(() {
                      _tickData = _tickData.copyWith(hasTick3: value);
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
