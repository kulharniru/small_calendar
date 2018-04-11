import 'dart:async';

/// Callback with a [DateTime].
typedef void DateTimeCallback(DateTime date);

/// Callback with year and month.
///
/// Both [year] and [month] start with one (january is 1).
typedef void YearMonthCallback(int year, int month);

/// Returns true/false based on if [day] has some property.
typedef Future<bool> IsHasCallback(DateTime day);
