
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/constants/searchdb_status.dart';
import 'package:nekodroid/provider/searchdb_status.dart';
import 'package:nekodroid/schemas/isar_anime_list.dart';
import 'package:nekodroid/schemas/isar_anime_list_item.dart';
import 'package:nekodroid/schemas/isar_episode_status.dart';
import 'package:nekodroid/schemas/isar_search_anime.dart';
import 'package:nekosama/nekosama.dart';


extension NekoSamaX on NekoSama {

  Future<void> checkSearchdb(WidgetRef ref) async {
    ref.read(searchdbStatusProv.notifier).update((_) => SearchdbStatus.verifying);
    try {
      final client = HttpClient();
      final request = await client.headUrl(
        Uri.https("neko-sama.fr", "/animes-search-vostfr.json"),
      )
        ..followRedirects = false
        ..persistentConnection = false;
      final head = await request.close();
      client.close();
      if (head.statusCode >= 400) {
        ref.read(searchdbStatusProv.notifier).update((_) => SearchdbStatus.errored);
        return;
      }
      final etag = head.headers.value("etag");
      final miscBox = Hive.box("misc-data");
      if (etag == null || etag != miscBox.get("searchdb-etag")) {
        miscBox.put("searchdb-etag", etag);
        return populateSearchdb(ref);
      }
      ref.read(searchdbStatusProv.notifier).update((_) => SearchdbStatus.ready);
    } on Exception catch (err) {
      ref.read(searchdbStatusProv.notifier).update(
        (_) => (err is NekoSamaException ? err.exception : err) is SocketException
          ? SearchdbStatus.erroredNoInternet
          : SearchdbStatus.errored,
      );
    }
  }

  Future<void> populateSearchdb(WidgetRef ref) async {
    ref.read(searchdbStatusProv.notifier).update((_) => SearchdbStatus.fetching);
    try {
      final data = await getRawSearchDb();
      ref.read(searchdbStatusProv.notifier).update((_) => SearchdbStatus.processing);
      Hive.box("misc-data").putAll(
        await compute(
          _populateSearchdbProcess,
          data,
        ),
      );
      ref.read(searchdbStatusProv.notifier).update((_) => SearchdbStatus.ready);
    } on Exception catch (err) {
      ref.read(searchdbStatusProv.notifier).update(
        (_) => (err is NekoSamaException ? err.exception : err) is SocketException
          ? SearchdbStatus.erroredNoInternet
          : SearchdbStatus.errored,
      );
    }
  }
}

Future<Map> _populateSearchdbProcess(List<Map<String, dynamic>> rawDb) async {
  final isar = await Isar.open(
    [
      IsarSearchAnimeSchema,
      IsarAnimeListItemSchema,
      IsarAnimeListSchema,
      IsarEpisodeStatusSchema,
    ],
    inspector: false,
  );
  final stats = {
    "searchdb-lowest-popularity": 0.0,
    "searchdb-highest-popularity": 0.0,
  };
  final animes = [
    ...rawDb.map((e) {
      final anime = IsarSearchAnime.fromRawSearchDb(e);
      if (anime.popularity < stats["searchdb-lowest-popularity"]!) {
        stats["searchdb-lowest-popularity"] = anime.popularity;
      }
      if (anime.popularity > stats["searchdb-highest-popularity"]!) {
        stats["searchdb-highest-popularity"] = anime.popularity;
      }
      return anime;
    })
  ];
  isar.writeTxnSync(() {
    isar.isarSearchAnimes
      ..clearSync()
      ..putAllSync(animes);
  });
  return stats;
}
