# small_calendar

small_calendar widget.

<img src="https://raw.githubusercontent.com/ZedTheLed/small_calendar/master/images/Screenshot_1.png" height="350px"/>

## Usage

### Add Dependency

```yaml
dependencies:
    small_calendar: "^0.4.0"
```

### Import It

```dart
import 'package:small_calendar/small_calendar.dart';
```

## Use It

1. Create new **SmallCalendarData** (this widget provides data to SmallCalendar-s down the widget tree)
2. (Optionally) Create **SmallCalendarStyle** (to change the looks of SmallCalendar)
3. Create **SmallCalendarPager** (to enable swiping between months)
4. In pageBuilder of SmallCalendarPager create a new **SmallCalendar**

If you wish to display SmallCalendar for only one Month (without the ability to swipe between months), omit the SmallCalendarPager. 

```dart
new SmallCalendarData(
  child: new SmallCalendarStyle(
    child: new SmallCalendarPager(
      pageBuilder: (BuildContext context, DateTime month) {
        return new SmallCalendar(
            month: month,
          );
        },
    ),
  ),
);
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
