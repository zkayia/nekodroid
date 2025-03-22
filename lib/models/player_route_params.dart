
import 'package:flutter/material.dart';
import 'package:nekosama/nekosama.dart';


@immutable
class PlayerRouteParams {

  final NSEpisode episode;
  final String title;
  final NSAnime? anime;
  final int? currentIndex;

  const PlayerRouteParams({
    required this.episode,
    required this.title,
    this.anime,
    this.currentIndex,
  }): assert(
    (anime == null && currentIndex == null)
    || (anime != null && currentIndex != null),
  );

  NSEpisode get currentEp => anime?.episodes.elementAt(currentIndex ?? 0) ?? episode;

  PlayerRouteParams copyWith({
    NSEpisode? episode,
    String? title,
    NSAnime? anime,
    int? currentIndex,
  }) => PlayerRouteParams(
    episode: episode ?? this.episode,
    title: title ?? this.title,
    anime: anime ?? this.anime,
    currentIndex: currentIndex ?? this.currentIndex,
  );

  @override
  String toString() =>
    "PlayerRouteParams(episode: $episode, title: $title, anime: $anime, currentIndex: $currentIndex)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is PlayerRouteParams
      && other.episode == episode
      && other.title == title
      && other.anime == anime
      && other.currentIndex == currentIndex;
  }

  @override
  int get hashCode => episode.hashCode
    ^ title.hashCode
    ^ anime.hashCode
    ^ currentIndex.hashCode;
}
