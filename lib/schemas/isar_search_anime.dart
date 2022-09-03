
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekosama/nekosama.dart';


part 'isar_search_anime.g.dart';


@collection
class IsarSearchAnime {
  
  Id id;
  String url;
  String thumbnail;
  String title;
  List<String> searchTitles;
  @enumerated
  List<NSGenres> genres;
  @enumerated
  NSTypes type;
  @enumerated
  NSStatuses status;
  double popularity;
  double score;
  int year;
  int episodeCount;

  IsarSearchAnime({
    required this.id,
    required this.url,
    required this.thumbnail,
    required this.title,
    required this.searchTitles,
    required this.genres,
    required this.type,
    required this.status,
    required this.popularity,
    required this.score,
    required this.year,
    required this.episodeCount,
  });

  @ignore
  Uri get urlUri => Uri.parse(url);
  
  @ignore
  Uri get thumbnailUri => Uri.parse(thumbnail);

  factory IsarSearchAnime.fromRawSearchDb(Map map) => IsarSearchAnime(
    id: map["id"] ?? 0,
    url: "https://neko-sama.fr${map["url"] ?? ""}",
    thumbnail: map["url_image"] ?? "",
    title: map["title"] ?? "",
    searchTitles: Isar.splitWords(
      [
        map["title"],
        map["title_english"],
        map["title_romanji"],
        map["title_french"],
        map["others"],
      ].whereType<String>().join(" "),
    ),
    genres: [
      for (final e in (map["genres"] as List?) ?? [])
        NSGenres.fromString(e),
    ].whereType<NSGenres>().toList(),
    type: NSTypes.fromString(map["type"] ?? "") ?? NSTypes.tv,
    status: NSStatuses.fromString(map["status"] ?? "") ?? NSStatuses.aired,
    popularity: map["popularity"] ?? 0.0,
    score: double.tryParse(map["score"] ?? "0.0") ?? 0.0,
    year: int.tryParse(map["start_date_year"] ?? "0") ?? 0,
    episodeCount: _extractEpisodeInt(map["nb_eps"] ?? "0"),
  );

  String dataText(BuildContext context) => "${
    type == NSTypes.movie
      ? ""
      : "${context.tr.episodeCountShort(episodeCount)} \u2022 " 
  }${
    context.tr.formats(type.name)
  } \u2022 ${
    context.tr.statuses(status.name)
  } \u2022 $year";
}

int _extractEpisodeInt(String episode) {
  final match = RegExp(r"\d+|film|\?").firstMatch(episode.toLowerCase())?.group(0);
  switch (match) {
    case "?":
      return 0;
    case "film":
      return 1;
    case null:
      throw NekoSamaException("unable to extract episode number from string $episode");
    default:
      return int.parse(match!);
  }
}
