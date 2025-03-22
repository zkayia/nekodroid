
import 'package:flutter/widgets.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/extensions/int.dart';


extension DateTimeX on DateTime {

  Duration diffToNow() => difference(DateTime.now()).abs();

  String prettyToString({bool seconds=false}) => "$day/$month/$year ${
    hour.toPaddedString()
  }:${
    minute.toPaddedString()
  }${
    seconds ? " ${second.toPaddedString()}" : ""
  }";

  String formatHistory(BuildContext context) => context.tr.dateAtTime(
    "$day ${
      context.tr.monthsShort("m$month")
    }.${
      year == DateTime.now().year
        ? ""
        : " $year"
    }",
    "${hour.toPaddedString()}:${minute.toPaddedString()}",
  );

  String completedOn(BuildContext context) => context.tr.completedOn(
    formatHistory(context),
  );
}
