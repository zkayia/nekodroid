import 'package:nekodroid/core/extensions/int.dart';

extension DurationX on Duration {
  String prettyToString({
    bool forceHoursDisplay = false,
    bool forceMinutesDisplay = true,
  }) {
    int duration = inMicroseconds;
    String result = "";
    if (forceHoursDisplay || duration >= Duration.microsecondsPerHour) {
      result = "${duration ~/ Duration.microsecondsPerHour}:";
      duration = duration.remainder(Duration.microsecondsPerHour);
    }
    if (forceMinutesDisplay || duration >= Duration.microsecondsPerMinute) {
      result = "$result${(duration ~/ Duration.microsecondsPerMinute).toPaddedString()}:";
      duration = duration.remainder(Duration.microsecondsPerMinute);
    }
    return "$result${(duration ~/ Duration.microsecondsPerSecond).toPaddedString()}";
  }
}
