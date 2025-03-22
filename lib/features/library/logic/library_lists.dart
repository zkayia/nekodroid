// import 'package:equatable/equatable.dart';
import 'package:drift/drift.dart';
import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/providers/db_sql.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_lists.g.dart';

@riverpod
Stream<List<LibraryList>> libraryLists(LibraryListsRef ref) {
  final db = ref.watch(dbSqlProvider);
  return (db.select(db.libraryLists)..orderBy([(tbl) => OrderingTerm.asc(tbl.position)])).watch();
}
