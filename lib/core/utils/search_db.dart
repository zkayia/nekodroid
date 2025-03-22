import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/providers/api.dart';
import 'package:nekodroid/core/providers/db_kv.dart';
import 'package:nekodroid/core/providers/db_sql.dart';
import 'package:nekodroid/core/providers/http_client.dart';
import 'package:nekodroid/core/utils/kv_db_utils.dart';
import 'package:nekodroid/features/search/logic/search_db_is_working.dart';
import 'package:nekodroid/features/settings/logic/settings.dart';
import 'package:nekosama/nekosama.dart';

class SearchDbUtils {
  const SearchDbUtils._();

  static Future<void> updateDb(WidgetRef ref, {bool force = false}) async {
    try {
      if (ref.read(searchDbIsWorkingProvider)) {
        return;
      }
      ref.read(searchDbIsWorkingProvider.notifier).isWorking();
      final List<Future<List<NSSearchAnime>>> requests = [];
      final enabledSources = ref.read(settingsProvider).searchSources;
      final client = ref.read(httpClientProvider);
      final api = ref.read(apiProvider);
      final dbKv = ref.read(dbKvProvider);
      for (final source in enabledSources) {
        final request = await client.headUrl(api.getSearchDbUrl(source))
          ..followRedirects = false
          ..persistentConnection = false;
        final head = await request.close();
        if (head.statusCode >= 400) {
          throw Exception("Failed to fetch search db head: ${source.apiName}");
        }
        final etag = head.headers.value("etag");
        final lastEtag = dbKv.getString(KvDbUtils.searchdbEtagSource(source));
        if (force || etag == null || lastEtag == null || etag != lastEtag) {
          if (etag != null) {
            await dbKv.setString(KvDbUtils.searchdbEtagSource(source), etag);
          }
          requests.add(api.getSearchDb(source));
        }
      }
      final searchDb = (await Future.wait(requests)).expand((e) => e);
      final db = ref.read(dbSqlProvider);
      await db.batch((batch) {
        batch.deleteWhere(db.searchAnimes, (tbl) => tbl.source.isNotIn(enabledSources.map((e) => e.name)));
        batch.insertAllOnConflictUpdate(
          db.searchAnimes,
          searchDb.map(
            (e) => SearchAnimesCompanion.insert(
              animeId: e.id,
              title: e.title,
              genres: e.genres,
              source: e.source,
              status: e.status,
              type: e.type,
              score: e.score,
              url: e.url,
              thumbnail: e.thumbnail,
              episodeCount: Value(e.episodeCount),
              year: e.year,
              popularity: e.popularity,
            ),
          ),
        );
      });
    } finally {
      ref.read(searchDbIsWorkingProvider.notifier).isNotWorking();
    }
  }

  static Future<void> clear(WidgetRef ref) async {
    try {
      if (ref.read(searchDbIsWorkingProvider)) {
        return;
      }
      ref.read(searchDbIsWorkingProvider.notifier).isWorking();
      final db = ref.read(dbSqlProvider);
      await db.delete(db.searchAnimes).go();
    } finally {
      ref.read(searchDbIsWorkingProvider.notifier).isNotWorking();
    }
  }
}
