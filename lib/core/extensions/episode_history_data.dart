import 'package:nekodroid/core/database/database.dart';

extension EpisodeHistoryDataX on EpisodeHistoryData {
  double get ratio => position.inMilliseconds / duration.inMilliseconds;
  bool get completed => ratio > 0.9;
}
