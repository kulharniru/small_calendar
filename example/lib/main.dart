import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'small_calendar_day_example.dart';

void main() {
  runApp(
    new SmallCalendarExample(),
  );
}

class SmallCalendarExample extends StatefulWidget {
  @override
  State createState() => new _SmallCalendarExampleState();
}

class _SmallCalendarExampleState extends State<SmallCalendarExample> {


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new SmallCalendarDayExample(),
    );
  }
}
