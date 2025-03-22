import 'package:drift/drift.dart';
import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/providers/db_sql.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history.g.dart';

@riverpod
class History extends _$History {
  @override
  Stream<List<(EpisodeHistoryData, Anime)>> build() {
    final db = ref.read(dbSqlProvider);
    final query = db.select(db.animes).join([innerJoin(db.episodeHistory, db.episodeHistory.animeUrl.equalsExp(db.animes.url))]);
    query.orderBy([OrderingTerm.desc(db.episodeHistory.time)]);
    return query.map((row) => (row.readTable(db.episodeHistory), row.readTable(db.animes))).watch();
  }

  Future<void> deleteEntry(EpisodeHistoryData entry) async {
    final db = ref.read(dbSqlProvider);
    await db.delete(db.episodeHistory).delete(entry);
  }
}
