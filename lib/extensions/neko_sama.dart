
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/constants/searchdb_status.dart';
import 'package:nekodroid/provider/searchdb_status.dart';
import 'package:nekodroid/schemas/isar_search_anime.dart';
import 'package:nekosama/nekosama.dart';


extension NekoSamaX on NekoSama {

  Future<void> checkSearchdb(WidgetRef ref) async {
    ref.read(searchdbStatusProv.notifier).update((_) => SearchdbStatus.fetching);
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
      ref.read(searchdbStatusProv.notifier).update((_) => SearchdbStatus.fetched);
    } on Exception {
      ref.read(searchdbStatusProv.notifier).update((_) => SearchdbStatus.errored);
    }
  }

  Future<void> populateSearchdb(WidgetRef ref) async {
    ref.read(searchdbStatusProv.notifier).update((_) => SearchdbStatus.fetching);
    await compute(
      _populateSearchdbProcess,
      await getRawSearchDb(),
    ).then(
      (_) => ref.read(searchdbStatusProv.notifier).update((_) => SearchdbStatus.fetched),
      onError: (_) =>
        ref.read(searchdbStatusProv.notifier).update((_) => SearchdbStatus.errored),
    );
  }
}

Future<void> _populateSearchdbProcess(List<Map<String, dynamic>> rawDb) async {
  final isar = await Isar.open([
    IsarSearchAnimeSchema,
  ]);
  final animes = [
    ...rawDb.map(IsarSearchAnime.fromRawSearchDb)
  ];
  isar.writeTxnSync(() {
    isar.isarSearchAnimes
      ..clearSync()
      ..putAllSync(animes);
  });
}
