import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class WeekdayIndicationStyle {
  WeekdayIndicationStyle.raw({
    @required this.weekdayIndicationHeight,
    @required this.textStyle,
    @required this.backgroundColor,
  })  : assert(weekdayIndicationHeight != null),
        assert(textStyle != null),
        assert(backgroundColor != null);

  factory WeekdayIndicationStyle({
    double weekdayIndicationHeight = 25.0,
    TextStyle textStyle,
    Color backgroundColor = Colors.blue,
  }) {
    return new WeekdayIndicationStyle.raw(
      weekdayIndicationHeight: weekdayIndicationHeight,
      textStyle: textStyle ?? new TextStyle(),
      backgroundColor: backgroundColor,
    );
  }

  /// Height of weekday indication area.
  final double weekdayIndicationHeight;

  /// [TextStyle] of weekday indication.
  final TextStyle textStyle;

  /// Background [Color] of weekday indication area.
  final Color backgroundColor;

  WeekdayIndicationStyle copyWith({
    double weekdayIndicationHeight,
    TextStyle textStyle,
    Color backgroundColor,
  }) {
    return new WeekdayIndicationStyle.raw(
      weekdayIndicationHeight:
          weekdayIndicationHeight ?? this.weekdayIndicationHeight,
      textStyle: textStyle ?? this.textStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
