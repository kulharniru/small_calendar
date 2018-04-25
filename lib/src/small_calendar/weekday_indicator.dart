import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'style/weekday_indication_style.dart';

class WeekdayIndicator extends StatelessWidget {
  WeekdayIndicator({
    @required this.text,
    @required this.weekdayIndicationStyle,
  })  : assert(text != null),
        assert(weekdayIndicationStyle != null);

  final String text;

  final WeekdayIndicationStyle weekdayIndicationStyle;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: new ClipRect(
          child: new Text(
            text,
            style: weekdayIndicationStyle.textStyle,
          ),
        ),
      ),
    );
  }
}
