import 'package:flutter/material.dart';

/// Signature for a function that creates a widget for a given [month].
///
/// Values of [month] except year and month will be set to default values.
typedef Widget SmallCalendarPageBuilder(BuildContext context, DateTime month);
