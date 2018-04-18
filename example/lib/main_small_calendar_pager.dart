import 'package:flutter/material.dart';

import 'package:small_calendar/small_calendar_pager.dart';

void main() {
  runApp(
    new SmallCalendarPagerExample(),
  );
}

class SmallCalendarPagerExample extends StatefulWidget {
  @override
  _SmallCalendarPagerExampleState createState() =>
      new _SmallCalendarPagerExampleState();
}

class _SmallCalendarPagerExampleState extends State<SmallCalendarPagerExample> {
  SmallCalendarPagerController controller;

  @override
  void initState() {
    super.initState();

    controller = new SmallCalendarPagerController(
      initialMonth: new DateTime(2018, 4),
      minimumMonth: new DateTime(2018, 2),
      maximumMonth: new DateTime(2018, 6),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "SmallCalendar Pager Example",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("SmallCalendar Pager Example"),
        ),
        body: new Container(
          constraints: new BoxConstraints.expand(),
          color: Colors.grey[200],
          child: new Center(
            child: new Column(
              children: <Widget>[
                new Container(
                  color: Colors.white,
                  margin: new EdgeInsets.symmetric(vertical: 50.0),
                  width: 300.0,
                  height: 300.0,
                  child: new SmallCalendarPager(
                    controller: new SmallCalendarPagerController(maximumMonth: new DateTime(2018,4)),
//controller: new SmallCalendarPagerController(maximumMonth: new DateTime(2018,5)),
//              controller: controller,
                    pageBuilder: (BuildContext context, DateTime month) {
                      return new Center(
                        child: new Text(
                            "year: ${month.year}\nmonth: ${month.month}"),
                      );
                    },
                  ),
                ),
                // -------------------------------------------------------------
                new Expanded(
                    child: new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 40.0),
                  child: new PageView(
                    controller: new PageController(initialPage: 1),
                    children: <Widget>[
                      new Text("a"),
                      new Text("b"),
                      new Text("c"),
                      new Text("d"),
                      new Text("e"),
                      new Text("f")
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
