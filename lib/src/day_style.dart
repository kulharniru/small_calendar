import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class DayStyle {
  // const indication ----------------------------------------------------------
  static const default_indicationFlex = 2;

  static const default_indicationBackgroundColor = Colors.transparent;

  static const default_dayIndicationTextStyle = const TextStyle();

  // const indication circle
  static const default_indicationCirclePadding = const EdgeInsets.all(2.0);

  static const default_indicationCircleColor = Colors.transparent;

  // const indication text
  static const default_indicationTextStyle = const TextStyle();

  // const ticks ---------------------------------------------------------------

  const DayStyle({
    // indication --------------------------------------------------------------
    this.indicationFlex = 2,
    this.indicationBackgroundColor = default_indicationBackgroundColor,
    // indication circle
    this.indicationCirclePadding = default_indicationCirclePadding,
    this.indicationCircleColor = default_indicationCircleColor,
    // indication text
    this.indicationTextStyle = default_dayIndicationTextStyle,
    // ticks -------------------------------------------------------------------
    this.ticksFlex = 1,
    this.ticksBackgroundColor = Colors.transparent,
    this.tick1Color = Colors.red,
    this.tick2Color = Colors.green,
    this.tick3Color = Colors.blue,
  });

  // indication ----------------------------------------------------------------
  final int indicationFlex;

  final Color indicationBackgroundColor;

  // indication circle
  final EdgeInsets indicationCirclePadding;

  final Color indicationCircleColor;

  // indication text
  final TextStyle indicationTextStyle;

  // ticks ---------------------------------------------------------------------
  // TODO Here

  final int ticksFlex;

  final Color ticksBackgroundColor;

  final Color tick1Color;

  final Color tick2Color;

  final Color tick3Color;
}
