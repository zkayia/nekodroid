import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:nekodroid/core/database/converters.dart';
import 'package:nekodroid/core/database/tables.dart';
import 'package:nekosama/nekosama.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

@DriftDatabase(tables: [SearchAnimes, Animes, LibraryLists, LibraryAnimes, EpisodeHistory])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> clear() async => Future.wait([
        ...allTables.map((table) => delete(table).go()),
      ]);

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          await customStatement("PRAGMA foreign_keys = OFF");
          if (kDebugMode) {
            final wrongForeignKeys = await customSelect("PRAGMA foreign_key_check").get();
            assert(wrongForeignKeys.isEmpty, "${wrongForeignKeys.map((e) => e.data)}");
          }
        },
        beforeOpen: (details) async {
          await customStatement("PRAGMA foreign_keys = ON");
        },
      );
}

QueryExecutor _openConnection() => LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(join(dbFolder.path, "nekodroid_db.sqlite"));

      if (Platform.isAndroid) {
        await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      }

      final cachebase = (await getTemporaryDirectory()).path;
      sqlite3.tempDirectory = cachebase;

      return NativeDatabase.createInBackground(file);
    });
