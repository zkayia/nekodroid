
import 'package:flutter/material.dart';
import 'package:nekodroid/constants/player_type.dart';
import 'package:nekosama/nekosama.dart';


@immutable
class PlayerRouteParams {

  final PlayerType playerType;
  final NSEpisode episode;
  final NSAnime? anime;
  final int? currentIndex;

  const PlayerRouteParams({
    required this.playerType,
    required this.episode,
    this.anime,
    this.currentIndex,
  }): assert(
    (anime == null && currentIndex == null)
    || (anime != null && currentIndex != null),
  );

  PlayerRouteParams copyWith({
    PlayerType? playerType,
    NSEpisode? episode,
    NSAnime? anime,
    int? currentIndex,
  }) => PlayerRouteParams(
    playerType: playerType ?? this.playerType,
    episode: episode ?? this.episode,
    anime: anime ?? this.anime,
    currentIndex: currentIndex ?? this.currentIndex,
  );
}
