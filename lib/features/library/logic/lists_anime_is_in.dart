import 'package:drift/drift.dart';
import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/providers/db_sql.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lists_anime_is_in.g.dart';

@riverpod
Stream<List<LibraryList>> listsAnimeIsIn(ListsAnimeIsInRef ref, Uri url) {
  final db = ref.watch(dbSqlProvider);
  final subquery = Subquery(
    db.select(db.libraryAnimes)..where((tbl) => tbl.animeUrl.equalsValue(url)),
    "libraryAnimes",
  );
  final query = db.select(db.libraryLists).join([
    innerJoin(
      subquery,
      subquery.ref(db.libraryAnimes.list).equalsExp(db.libraryLists.name),
      useColumns: false,
    ),
  ]);
  return query.map((row) => row.readTable(db.libraryLists)).watch();
}
