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
  SmallCalendarPagerController smallCalendarPagerController;

  String displayedMonthText;

  @override
  void initState() {
    super.initState();

    DateTime initialMonth = new DateTime.now();
    DateTime minimumMonth =
        new DateTime(initialMonth.year - 1, initialMonth.month);
    DateTime maximumMonth =
        new DateTime(initialMonth.year + 1, initialMonth.month);

    displayedMonthText = "${initialMonth.year}.${initialMonth.month}";

    smallCalendarPagerController = new SmallCalendarPagerController(
      initialMonth: initialMonth,
      minimumMonth: minimumMonth,
      maximumMonth: maximumMonth,
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
                  margin: new EdgeInsets.only(top: 50.0),
                  width: 300.0,
                  height: 300.0,
                  child: new SmallCalendarPager(
                    controller: smallCalendarPagerController,
                    onMonthChanged: (DateTime displayedMonth) {
                      setState(() {
                        displayedMonthText =
                            "${displayedMonth.year}.${displayedMonth.month}";
                      });
                    },
                    pageBuilder: (BuildContext context, DateTime month) {
                      return new Center(
                        child: new Text(
                          "year: ${month.year}\nmonth: ${month.month}",
                        ),
                      );
                    },
                  ),
                ),
                // -------------------------------------------------------------
                new Expanded(
                    child: new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 40.0),
                  child: new SingleChildScrollView(
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          margin: new EdgeInsets.symmetric(vertical: 8.0),
                          child: new Text(displayedMonthText),
                        ),
                        new RaisedButton(
                          child: new Text("Jump to initial Month"),
                          onPressed: () {
                            smallCalendarPagerController.jumpToMonth(
                              smallCalendarPagerController.initialMonth,
                            );
                          },
                        )
                      ],
                    ),
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
