
import 'package:isar/isar.dart';
import 'package:nekodroid/schemas/isar_anime_list_item.dart';


part 'isar_episode_status.g.dart';


@collection
class IsarEpisodeStatus {
  
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true, caseSensitive: false, type: IndexType.hash)
  String url;
  String thumbnail;
  int episodeNumber;
  int? lastWatchedTimestamp;
  List<int> watchedTimestamps;

  @Backlink(to: "episodeStatuses")
  final anime = IsarLink<IsarAnimeListItem>();

  IsarEpisodeStatus({
    required this.url,
    required this.thumbnail,
    required this.episodeNumber,
    required this.lastWatchedTimestamp,
    required this.watchedTimestamps,
  });

  @ignore
  Uri get urlUri => Uri.parse(url);
  
  @ignore
  Uri get thumbnailUri => Uri.parse(thumbnail);
  
}
