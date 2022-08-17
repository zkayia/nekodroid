
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nekodroid/extensions/int.dart';


extension DurationX on Duration {

  String prettyToString({
    bool forceHoursDisplay=false,
    bool forceMinutesDisplay=true,
  }) {
    int duration = inMicroseconds;
    String result = "";
    if (forceHoursDisplay || duration >= Duration.microsecondsPerHour) {
      result = "${duration ~/ Duration.microsecondsPerHour}:";
      duration = duration.remainder(Duration.microsecondsPerHour);
    }
    if (forceMinutesDisplay || duration >= Duration.microsecondsPerMinute) {
      result = "$result${
        (duration ~/ Duration.microsecondsPerMinute).toPaddedString()
      }:";
      duration = duration.remainder(Duration.microsecondsPerMinute);
    }
    return "$result${
      (duration ~/ Duration.microsecondsPerSecond).toPaddedString()
    }";
  }

  String toUnitsString({
    required AppLocalizations unitsTranslations,
    bool useLongFormat=false,
    bool forceHoursDisplay=false,
    bool forceMinutesDisplay=false,
    bool forceSecondsDisplay=false,
    String separator=" ",
  }) {
    int duration = inMicroseconds;
    String result = "";
    if (forceHoursDisplay || duration >= Duration.microsecondsPerHour) {
      result = "${
        useLongFormat
          ? unitsTranslations.hoursLong(duration ~/ Duration.microsecondsPerHour)
          : unitsTranslations.hoursShort(duration ~/ Duration.microsecondsPerHour)
      }$separator";
      duration = duration.remainder(Duration.microsecondsPerHour);
    }
    if (forceMinutesDisplay || duration >= Duration.microsecondsPerMinute) {
      result = "$result${
        useLongFormat
          ? unitsTranslations.minutesLong(duration ~/ Duration.microsecondsPerMinute)
          : unitsTranslations.minutesShort(duration ~/ Duration.microsecondsPerMinute)
      }$separator";
      duration = duration.remainder(Duration.microsecondsPerMinute);
    }
    if (forceSecondsDisplay || duration >= Duration.microsecondsPerSecond) {
      result = "$result${
        useLongFormat
          ? unitsTranslations.secondsLong(duration ~/ Duration.microsecondsPerSecond)
          : unitsTranslations.secondsShort(duration ~/ Duration.microsecondsPerSecond)
      }";
      duration = duration.remainder(Duration.microsecondsPerSecond);
    }
    return result.trim();
  }
}
