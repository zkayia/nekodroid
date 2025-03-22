
import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:nekodroid/schemas/isar_anime_list_item.dart';
import 'package:nekosama/nekosama.dart';


part 'isar_episode_status.g.dart';


@collection
class IsarEpisodeStatus {
  
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true, caseSensitive: false, type: IndexType.hash)
  String url;
  String thumbnail;
  int episodeNumber;
  // In milliseconds
  int? duration;
  // In milliseconds
  int? lastPosition;
  int? lastExitTimestamp;
  List<int> watchedTimestamps;

  @Backlink(to: "episodeStatuses")
  final anime = IsarLink<IsarAnimeListItem>();

  IsarEpisodeStatus({
    required this.url,
    required this.thumbnail,
    required this.episodeNumber,
    required this.duration,
    required this.lastPosition,
    required this.lastExitTimestamp,
    required this.watchedTimestamps,
  });

  @ignore
  Set<int> get watchedTimestampsSet => watchedTimestamps.toSet();

  @ignore
  double? get watchedFraction => lastPosition != null && duration != null
    ? lastPosition! / duration!
    : null;

  @ignore
  bool? get watchedOnLastExit => lastExitTimestamp != null && watchedTimestamps.isNotEmpty
    ? lastExitTimestamp == watchedTimestamps.last
    : null;

  @ignore
  Duration? get lastPositionDuration => lastPosition == null
    ? null
    : Duration(milliseconds: lastPosition!);
  
  @ignore
  DateTime? get lastExitDateTime => lastExitTimestamp == null
    ? null
    : DateTime.fromMillisecondsSinceEpoch(lastExitTimestamp!);
  
  @ignore
  DateTime? get lastWatchedDateTime => watchedTimestamps.isEmpty
    ? null
    : DateTime.fromMillisecondsSinceEpoch(watchedTimestamps.last);

  @ignore
  Uri get urlUri => Uri.parse(url);
  
  @ignore
  Uri get thumbnailUri => Uri.parse(thumbnail);

  factory IsarEpisodeStatus.fromNSEpisode(
    NSEpisode episode,
    [
      int? lastPosition,
      int? lastExitTimestamp,
      List<int>? watchedTimestamps,
    ]
  ) => IsarEpisodeStatus(
    url: episode.url.toString(),
    thumbnail: episode.thumbnail.toString(),
    episodeNumber: episode.episodeNumber,
    duration: episode.duration?.inMilliseconds,
    lastPosition: lastPosition,
    lastExitTimestamp: lastExitTimestamp,
    watchedTimestamps: watchedTimestamps ?? const [],
  );

  Map<String, dynamic> toMap() => {
    "url": url,
    "thumbnail": thumbnail,
    "episodeNumber": episodeNumber,
    "duration": duration,
    "lastPosition": lastPosition,
    "lastExitTimestamp": lastExitTimestamp,
    "watchedTimestamps": watchedTimestamps,
  };

  factory IsarEpisodeStatus.fromMap(Map<String, dynamic> map) => IsarEpisodeStatus(
    url: map["url"],
    thumbnail: map["thumbnail"],
    episodeNumber: map["episodeNumber"],
    duration: map["duration"],
    lastPosition: map["lastPosition"],
    lastExitTimestamp: map["lastExitTimestamp"],
    watchedTimestamps: List<int>.from(map["watchedTimestamps"]),
  );

  String toJson() => json.encode(toMap());

  factory IsarEpisodeStatus.fromJson(String source) => IsarEpisodeStatus.fromMap(json.decode(source));
}
