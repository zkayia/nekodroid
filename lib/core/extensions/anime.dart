import 'package:collection/collection.dart';
import 'package:nekodroid/core/database/database.dart';

extension AnimeX on Anime {
  Anime get sorted => copyWith(episodes: episodes.sorted((a, b) => a.episodeNumber.compareTo(b.episodeNumber)));
}
