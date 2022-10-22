
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
  int? lastExitTime;
  List<int> watchedTimestamps;

  @Backlink(to: "episodeStatuses")
  final anime = IsarLink<IsarAnimeListItem>();

  IsarEpisodeStatus({
    required this.url,
    required this.thumbnail,
    required this.episodeNumber,
    required this.lastExitTime,
    required this.watchedTimestamps,
  });

  int? get lastWatchedTimestamp => watchedTimestamps.isEmpty
    ? null
    : watchedTimestamps.last;

  @ignore
  Uri get urlUri => Uri.parse(url);
  
  @ignore
  Uri get thumbnailUri => Uri.parse(thumbnail);

  factory IsarEpisodeStatus.fromNSEpisode(
    NSEpisode episode,
    [
      int? lastExitTime,
      List<int>? watchedTimestamps,
    ]
  ) => IsarEpisodeStatus(
    url: episode.url.toString(),
    thumbnail: episode.thumbnail.toString(),
    episodeNumber: episode.episodeNumber,
    lastExitTime: lastExitTime,
    watchedTimestamps: watchedTimestamps ?? const [],
  );
  
}
