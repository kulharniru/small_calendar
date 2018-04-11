# small_calendar

small_calendar widget.

<img src="https://raw.githubusercontent.com/ZedTheLed/small_calendar/master/images/Screenshot_1.png" height="350px"/>

## Usage

### Add Dependency

```yaml
dependencies:
    small_calendar: "^0.3.0"
```

### Import It

```dart
import 'package:small_calendar/small_calendar.dart';
```
## Styling

<img src="https://raw.githubusercontent.com/ZedTheLed/small_calendar/master/images/items_explanation.png" height="300px"/>

* **1.** - weekdayIndicationHeight
* **2.** - WeekdayIndicationStyleData/textStyle
* **3.** - WeekdayIndicationStyleData/backgroundColor
* **4.** - DayStyleData/extendedDayTextStyle
* **5.** - DayStyleData/dayTextStyle
* **6.** - tick
* **7.** - textTickSeparation 
* **8.** - selectedColor
* **9.** - todayColor

## Tips

If you call setState() inside onDisplayedMonthChanged the calendar ticks might flicker. 
To avoid this save SmallCalendar widget as a variable and only create a new SmallCalendar when you really need to (as is done in example).
