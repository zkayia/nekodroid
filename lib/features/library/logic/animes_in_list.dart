import 'package:drift/drift.dart';
import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/providers/db_sql.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'animes_in_list.g.dart';

@riverpod
Stream<List<Anime>> animesInList(AnimesInListRef ref, String list) {
  final db = ref.watch(dbSqlProvider);
  final subquery = Subquery(
    db.select(db.libraryAnimes)..where((tbl) => tbl.list.equals(list)),
    "libraryAnimes",
  );
  final query = db
      .select(db.animes)
      .join([innerJoin(subquery, subquery.ref(db.libraryAnimes.animeUrl).equalsExp(db.animes.url), useColumns: false)]);
  query.orderBy([OrderingTerm.desc(subquery.ref(db.libraryAnimes.addedAt))]);
  return query.map((row) => row.readTable(db.animes)).watch();
}
