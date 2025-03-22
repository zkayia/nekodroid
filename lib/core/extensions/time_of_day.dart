import 'package:nekodroid/core/extensions/int.dart';
import 'package:flutter/material.dart';

extension TimeOfDayX on TimeOfDay {
  bool operator <(TimeOfDay other) => hour < other.hour || (hour == other.hour && minute < other.minute);

  bool operator <=(TimeOfDay other) => this == other || this < other;

  bool operator >(TimeOfDay other) => hour > other.hour || (hour == other.hour && minute > other.minute);

  bool operator >=(TimeOfDay other) => this == other || this > other;

  TimeOfDay add({int hours = 0, int minutes = 0}) {
    final newHour = (hour + hours) % 24;
    final newMinute = minute + minutes;
    return TimeOfDay(
      hour: newHour + newMinute ~/ 60,
      minute: newMinute % 60,
    );
  }

  Duration difference(TimeOfDay other) => Duration(
        minutes: (hour - other.hour) * 60 + minute - other.minute,
      );

  String toPrettyString() => "${hour.toPaddedString()}:${minute.toPaddedString()}";
}
