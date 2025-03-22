import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/extensions/int.dart';
import 'package:nekodroid/core/extensions/time_of_day.dart';
import 'package:flutter/material.dart';

extension DateTimeX on DateTime {
  bool get isLeapYear => (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  int get dayPerMonth => month == 2 ? 28 + (isLeapYear ? 1 : 0) : 31 - (month - 1) % 7 % 2;

  DateTime get endOfDay => copyWith(
        hour: 23,
        minute: 59,
        second: 59,
        millisecond: 999,
        microsecond: 999,
      );

  DateTime get midnight => copyWith(year: year, month: month, day: day);
  DateTime get midnightUtc => DateTime.utc(year, month, day);

  String get monthLabel => kMonths.elementAt(month - 1);
  DateTime get monthStart => midnight.subtract(Duration(days: day - 1));
  DateTime get monthEnd => monthStart.add(Duration(days: dayPerMonth - 1)).endOfDay;

  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

  String get weekdayLabel => kWeekDays.elementAt(weekday - 1);
  DateTime get weekStart => midnight.subtract(Duration(days: weekday - 1));
  DateTime get weekEnd => weekStart.add(const Duration(days: 6)).endOfDay;

  int daysBetween(DateTime other) => midnightUtc.difference(other.midnightUtc).abs().inDays;
  Duration diffToNow() => difference(DateTime.now()).abs();

  String format() => "${year.toPaddedString(4)}/${month.toPaddedString()}/${day.toPaddedString()} ${formatTime()}";
  String formatDay() => "${year.toPaddedString(4)}-${month.toPaddedString()}-${day.toPaddedString()}";
  String formatTime() => "${hour.toPaddedString()}:${minute.toPaddedString()}";

  bool isSameDayAs(DateTime other) => year == other.year && month == other.month && day == other.day;

  String toPrettyMonth() => "$monthLabel $year";
  String toPrettyDay() => "$weekdayLabel $day";
  String toPrettyDayMonth() => "$weekdayLabel $day $monthLabel";
  String toPrettyDayMonthHour() => "$weekdayLabel $day $monthLabel, ${timeOfDay.toPrettyString()}";

  DateTime withTimeOfDay(TimeOfDay timeOfDay) => copyWith(
        hour: timeOfDay.hour,
        minute: timeOfDay.minute,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
}
