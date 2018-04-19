import 'dart:async';

/// Callback with a [DateTime].
///
/// Values except year, month and day are set to their default values.
typedef void DateCallback(DateTime date);

/// Returns true/false based on if [day] has some property.
typedef Future<bool> IsHasCallback(DateTime day);
