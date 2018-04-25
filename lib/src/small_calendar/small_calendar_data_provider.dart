import 'dart:async';

import 'package:flutter/material.dart';

import 'callbacks.dart';

class SmallCalendarInformationProvider {
  /// Creates a new instance of [SmallCalendarInformationProvider].
  SmallCalendarInformationProvider({
    this.isTodayCallback,
    this.isSelectedCallback,
    this.hasTick1Callback,
    this.hasTick2Callback,
    this.hasTick3Callback,
  });

  /// Future that returns true if a day is today.
  final IsHasCallback isTodayCallback;

  /// Future that returns true if a day is selected.
  final IsHasCallback isSelectedCallback;

  /// Future that returns true if there is a tick1 associated with a day.
  final IsHasCallback hasTick1Callback;

  /// Future that returns true if there is a tick2 associated with a day.
  final IsHasCallback hasTick2Callback;

  /// Future that returns true if there is a tick3 associated with a day.
  final IsHasCallback hasTick3Callback;

  /// Listeners provided by [SmallCalendar], to notify them to refresh day information.
  Set<VoidCallback> _refreshListeners = new Set<VoidCallback>();

  /// Registers a given [refreshListener] with the controller.
  ///
  /// Multiple refresh listeners can be attached.
  /// It is recommended that all [SmallCalendar] widgets attach to the same [SmallCalendarInformationProvider].
  void attach(VoidCallback refreshListener) {
    _refreshListeners.add(refreshListener);
  }

  /// Unregisters the previously attached [refreshListener].
  void detach(VoidCallback refreshListener) {
    _refreshListeners.remove(refreshListener);
  }

  /// Notifies all attached [SmallCalendar]s to refresh their day information.
  ///
  /// Calling this will prompt all attached [SmallCalendar]s
  /// to refresh their day information (isSelected, hasTick1, ...).
  void refresh() {
    for (VoidCallback refreshListener in _refreshListeners) {
      refreshListener();
    }
  }

  // is has --------------------------------------------------------------------

  /// Future that returns true if [day] should be marked as today.
  Future<bool> isToday(DateTime day) async {
    if (isTodayCallback != null) {
      return isTodayCallback(day);
    }

    // default
    return false;
  }

  /// Future that returns true if [day] should be marked as selected.
  Future<bool> isSelected(DateTime day) async {
    if (isSelectedCallback != null) {
      return isSelectedCallback(day);
    }

    // default
    return false;
  }

  /// Future that returns true if [day] has a tick1.
  Future<bool> hasTick1(DateTime day) async {
    if (hasTick1Callback != null) {
      return hasTick1Callback(day);
    }

    // default
    return false;
  }

  /// Future that returns true if [day] has a tick2.
  Future<bool> hasTick2(DateTime day) async {
    if (hasTick2Callback != null) {
      return hasTick2Callback(day);
    }

    // default
    return false;
  }

  /// Future that returns true if [day] has a tick3.
  Future<bool> hasTick3(DateTime day) async {
    if (hasTick3Callback != null) {
      return hasTick3Callback(day);
    }

    // default
    return false;
  }
}
