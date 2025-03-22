import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:nekodroid/core/database/database.dart' as database;
import 'package:nekodroid/core/extensions/episode_history_data.dart';
import 'package:nekodroid/core/providers/api.dart';
import 'package:nekodroid/core/providers/db_sql.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'anime.g.dart';

@riverpod
class Anime extends _$Anime {
  @override
  Stream<database.Anime> build(Uri url) async* {
    final db = ref.watch(dbSqlProvider);
    final query = db.select(db.animes)..where((tbl) => tbl.url.equalsValue(url));
    final dbAnime = await query.getSingleOrNull();
    if (dbAnime != null) {
      yield dbAnime;
    }
    await _fetchAndAdd(db, url, dbAnime?.lastModified);
    yield* query.watchSingle();
  }

  Future<void> refresh() => _fetchAndAdd(ref.read(dbSqlProvider), url, null);

  Future<void> _fetchAndAdd(database.AppDatabase db, Uri url, String? lastModified) async {
    final api = ref.read(apiProvider);
    final request = await api.httpClient.getUrl(url)
      ..followRedirects = false
      ..persistentConnection = false;
    if (lastModified != null) {
      request.headers.add(HttpHeaders.ifModifiedSinceHeader, lastModified);
    }
    final response = await request.close();
    if (response.statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      final anime = api.extractAnime(url, body);
      await db.into(db.animes).insertOnConflictUpdate(
            database.AnimesCompanion.insert(
              animeId: anime.id,
              title: anime.title,
              url: anime.url,
              thumbnail: anime.thumbnail,
              episodeCount: Value.absentIfNull(anime.episodeCount),
              titles: anime.titles,
              genres: anime.genres,
              source: anime.source,
              status: anime.status,
              type: anime.type,
              score: anime.score,
              synopsis: Value.absentIfNull(anime.synopsis),
              episodes: anime.episodes,
              startDate: Value.absentIfNull(anime.startDate),
              endDate: Value.absentIfNull(anime.endDate),
              lastModified: Value.absentIfNull(response.headers.value(HttpHeaders.lastModifiedHeader)),
            ),
          );
    }
  }

  Future<int> getEpToPlayIndex(int episodeCount) async {
    final db = ref.read(dbSqlProvider);
    final latestEp = await (db.select(db.episodeHistory)
          ..where((tbl) => tbl.animeUrl.equalsValue(url))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.time), (tbl) => OrderingTerm.desc(tbl.episodeNumber)])
          ..limit(1))
        .getSingleOrNull();
    var episodeIndex = max((latestEp?.episodeNumber ?? 1) - 1, 0);
    if (latestEp?.completed ?? false) {
      episodeIndex++;
    }
    if (episodeIndex >= episodeCount) {
      episodeIndex = 0;
    }
    return episodeIndex;
  }
}
