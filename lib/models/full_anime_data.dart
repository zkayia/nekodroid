
import 'package:flutter/foundation.dart';
import 'package:nekosama/nekosama.dart';
import 'package:nekodroid/schemas/isar_anime_list_item.dart';


@immutable
class FullAnimeData {

  final NSAnime anime;
  final IsarAnimeListItem? isarAnime;
  
  const FullAnimeData({
    required this.anime,
    this.isarAnime,
  });

  FullAnimeData copyWith({
    NSAnime? anime,
    IsarAnimeListItem? isarAnime,
  }) => FullAnimeData(
    anime: anime ?? this.anime,
    isarAnime: isarAnime ?? this.isarAnime,
  );

  @override
  String toString() => "FullAnimeData(anime: $anime, isarAnime: $isarAnime)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is FullAnimeData && other.anime == anime && other.isarAnime == isarAnime;
  }

  @override
  int get hashCode => anime.hashCode ^ isarAnime.hashCode;
}
