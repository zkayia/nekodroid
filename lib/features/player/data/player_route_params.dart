import 'package:equatable/equatable.dart';
import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/extensions/anime.dart';
import 'package:nekosama/nekosama.dart';

class PlayerRouteParams extends Equatable {
  final NSEpisode episode;
  final String title;
  final Uri? animeUrl;
  final Anime? anime;

  const PlayerRouteParams({
    required this.episode,
    required this.title,
    this.animeUrl,
    this.anime,
  }) : assert(animeUrl != null || anime != null, "Either anime or animeUrl must be provided");

  PlayerRouteParams? get previous => anime != null && 1 < episode.episodeNumber
      ? copyWith(episode: anime?.sorted.episodes.elementAt(episode.episodeNumber - 2))
      : null;
  PlayerRouteParams? get next => anime != null && episode.episodeNumber < anime!.episodes.length
      ? copyWith(episode: anime?.sorted.episodes.elementAt(episode.episodeNumber))
      : null;

  @override
  List<Object?> get props => [episode, title, anime];

  PlayerRouteParams copyWith({
    NSEpisode? episode,
    String? title,
    Uri? animeUrl,
    Anime? anime,
  }) =>
      PlayerRouteParams(
        episode: episode ?? this.episode,
        title: title ?? this.title,
        animeUrl: animeUrl ?? this.animeUrl,
        anime: anime ?? this.anime,
      );
}
