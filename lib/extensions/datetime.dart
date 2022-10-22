
import 'package:flutter/widgets.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/extensions/int.dart';


extension DateTimeX on DateTime {

  Duration diffToNow() => difference(DateTime.now()).abs();

  String prettyToString() => "$day/$month/$year ${
    hour.toPaddedString()
  }:${
    minute.toPaddedString()
  }:${
    second.toPaddedString()
  }";

  String formatHistory(BuildContext context) => "$day ${
    context.tr.monthsShort(month)
  }. ${
    year == DateTime.now().year
      ? ""
      : "$year "
  }${
    hour.toPaddedString()
  }:${
    minute.toPaddedString()
  }";
}
