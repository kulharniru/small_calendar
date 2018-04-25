import 'dart:async';

import 'package:flutter/material.dart';

import 'package:small_calendar/small_calendar.dart';

void main() {
  runApp(
    new SmallCalendarExampleApp(),
  );
}

class SmallCalendarExampleApp extends StatefulWidget {
  @override
  State createState() => new _SmallCalendarExampleAppState();
}

class _SmallCalendarExampleAppState extends State<SmallCalendarExampleApp> {
  bool showWeekdayIndication = true;
  bool showTicks = true;
  SmallCalendarDataProvider smallCalendarController =
      createSmallCalendarController();

  SmallCalendarDataProvider smallCalendarController2 =
      new SmallCalendarDataProvider(
          initialDate: new DateTime.now().add(new Duration(days: 30)));

  String displayedMonthText;

  @override
  void initState() {
    super.initState();

    DateTime displayedMonth = smallCalendarController.displayedMonth;
    displayedMonthText =
        "Displaying ${displayedMonth.year}.${displayedMonth.month}";
  }

  Widget buildSmallCalendar(BuildContext context) {
    return new SmallCalendar(
      firstWeekday: DateTime.monday,
      dataProvider: smallCalendarController,
      dayStyle: new DayStyle(
        showTicks: showTicks,
        tick3Color: Colors.yellow[700],
      ),
      showWeekdayIndication: showWeekdayIndication,
      weekdayIndicationStyle: new WeekdayIndicationStyle(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      onDaySelected: (DateTime date) {
        Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text(
                "Pressed on ${date.year}.${date.month}.${date.day}",
              ),
            ));
      },
      onDisplayedMonthChanged: (int year, int month) {
        setState(() {
          DateTime displayedMonth = smallCalendarController.displayedMonth;
          displayedMonthText =
              "Displaying ${displayedMonth.year}.${displayedMonth.month}";
          print(displayedMonthText);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(textTheme: new TextTheme(body1: new TextStyle())),
      title: "small_calendar example",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("small_calendar example"),
        ),
        body:
            // Creates an inner BuildContext so that the onDayPressed method in SmallCalendar
            // can refer to the Scaffold with Scaffold.of().
            new Builder(
          builder: (BuildContext context) {
            return new Column(
              children: <Widget>[
                // calendar
                new Expanded(
                  child: new Container(
                    color: Colors.grey[300],
                    child: new Center(
                      child: new Container(
                        width: 250.0,
                        height: 250.0,
                        color: Theme.of(context).cardColor,
                        // Small Calendar ------------------------------------------
                        child: buildSmallCalendar(context),
                        // ---------------------------------------------------------
                      ),
                    ),
                  ),
                ),
                // controls
                new Expanded(
                  child: new SingleChildScrollView(
                    child: new Column(
                      children: <Widget>[
                        // show weekday indication
                        new Container(
                          padding: new EdgeInsets.only(top: 4.0),
                          child: new Text(displayedMonthText),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Checkbox(
                              value: showWeekdayIndication,
                              onChanged: (newValue) {
                                setState(() {
                                  showWeekdayIndication = newValue;
                                });
                              },
                            ),
                            new Text("Show Weekday Indication"),
                          ],
                        ),
                        // show ticks
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Checkbox(
                                value: showTicks,
                                onChanged: (newValue) {
                                  setState(() {
                                    showTicks = newValue;
                                  });
                                }),
                            new Text("Show Ticks"),
                          ],
                        ),
                        new RaisedButton(
                          child: new Text("Go to today"),
                          onPressed: () {
                            smallCalendarController.goToToday();
                          },
                        ),
                        new Container(
                          height: 8.0,
                        ),
                        new RaisedButton(
                          child: new Text("Refresh"),
                          onPressed: () {
                            //smallCalendarController.refreshDayInformation();
                            setState(() {
                              smallCalendarController =
                                  smallCalendarController2;
                            });
                          },
                        ),
                        new Divider(),
                        new Container(
                          padding: new EdgeInsets.symmetric(horizontal: 16.0),
                          child: new Text(
                            """When you click on Refresh Button it might seem that nothing happened. But the calendar has actually refreshed, just that data is the same.

For example purpuses:
                    * every first day of month has tick1
                    * every second day of month has tick2
                    * every third day of month has tick3
                    * every fourth day of month has tick1 and tick2
                    * every fifth day of month has tick1, tick2 and tick3
                    * every tenth day of month is selected
                    """,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

SmallCalendarDataProvider createSmallCalendarController() {
  Future<bool> isSelectedCallback(DateTime day) async {
    if (day.day == 10) {
      return true;
    }

    return false;
  }

  Future<bool> hasTick1Callback(DateTime day) async {
    if (day.day == 1 || day.day == 4 || day.day == 5) {
      return true;
    }

    return false;
  }

  Future<bool> hasTick2Callback(DateTime day) async {
    if (day.day == 2 || day.day == 4 || day.day == 5) {
      return true;
    }

    return false;
  }

  Future<bool> hasTick3Callback(DateTime day) async {
    if (day.day == 3 || day.day == 5) {
      return true;
    }

    return false;
  }

  return new SmallCalendarDataProvider(
    isSelectedCallback: isSelectedCallback,
    hasTick1Callback: hasTick1Callback,
    hasTick2Callback: hasTick2Callback,
    hasTick3Callback: hasTick3Callback,
  );
}
