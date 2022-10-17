
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:nekosama/nekosama.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/schemas/isar_anime_list.dart';
import 'package:nekodroid/schemas/isar_episode_status.dart';


part 'isar_anime_list_item.g.dart';


@collection
class IsarAnimeListItem {
  
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true, caseSensitive: false, type: IndexType.hash)
  String url;
  String title;
  String thumbnail;
  @enumerated
  NSTypes type;
  @enumerated
  NSStatuses status;
  int? year;
  int episodeCount;
  int? favoritedTimestamp;

  final episodeStatuses = IsarLinks<IsarEpisodeStatus>();
  @Backlink(to: "animes")
  final lists = IsarLinks<IsarAnimeList>();

  IsarAnimeListItem({
    required this.url,
    required this.title,
    required this.thumbnail,
    required this.type,
    required this.status,
    required this.year,
    required this.episodeCount,
    required this.favoritedTimestamp,
  });

  @ignore
  Uri get urlUri => Uri.parse(url);
  
  @ignore
  Uri get thumbnailUri => Uri.parse(thumbnail);

  String dataText(BuildContext context) => "${
      type == NSTypes.movie
        ? ""
        : "${context.tr.episodeCountShort(episodeCount)} \u2022 " 
    }${
      context.tr.types(type.name)
    } \u2022 ${
      context.tr.statuses(status.name)
    } \u2022 ${year ?? "?"}";

  IsarAnimeListItem copyWith({
    String? url,
    String? title,
    String? thumbnail,
    NSTypes? type,
    NSStatuses? status,
    int? year,
    int? episodeCount,
    int? favoritedTimestamp,
  }) => IsarAnimeListItem(
    url: url ?? this.url,
    title: title ?? this.title,
    thumbnail: thumbnail ?? this.thumbnail,
    type: type ?? this.type,
    status: status ?? this.status,
    year: year ?? this.year,
    episodeCount: episodeCount ?? this.episodeCount,
    favoritedTimestamp: favoritedTimestamp ?? this.favoritedTimestamp,
  );

  factory IsarAnimeListItem.fromNSAnime(
    NSAnimeExtendedBase anime,
    [
      int? favoritedTimestamp,
    ]
  ) => IsarAnimeListItem(
    url: anime.url.toString(),
    title: anime.title,
    thumbnail: anime.thumbnail.toString(),
    type: anime.type,
    status: anime.status,
    year: anime is NSAnime
      ? anime.startDate?.year
      : anime is NSSearchAnime
        ? anime.year
        : null,
    episodeCount: anime.episodeCount,
    favoritedTimestamp: null,
  );
}
