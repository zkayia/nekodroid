import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/extensions/int.dart';
import 'package:nekodroid/core/providers/db_kv.dart';
import 'package:nekodroid/core/providers/db_sql.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backup.g.dart';

typedef DbTable = TableInfo<Table, Object?>;
typedef DataClassFromJson = Insertable Function(Map<String, dynamic>, {ValueSerializer? serializer});

@riverpod
class Backup extends _$Backup {
  @override
  BackupState build() => const IdleBackupState();

  String _exportFilename(DateTime datetime) {
    final date = "${datetime.year.toPaddedString(4)}-${datetime.month.toPaddedString()}-${datetime.day.toPaddedString()}";
    final time = [datetime.hour, datetime.minute, datetime.second].map((e) => e.toPaddedString()).join("-");
    return "nekodroid_${date}_$time.json";
  }

  List<(DbTable, DataClassFromJson)> _tablesToBackup(AppDatabase db) => [
        (db.animes, Anime.fromJson),
        (db.libraryLists, LibraryList.fromJson),
        (db.libraryAnimes, LibraryAnime.fromJson),
        (db.episodeHistory, EpisodeHistoryData.fromJson),
      ];

  Future<void> export() async {
    try {
      state = const ExportingBackupState();
      final backup = <String, dynamic>{
        "shared_preferences": <String, dynamic>{},
      };
      final dbKv = ref.read(dbKvProvider);
      for (final key in dbKv.getKeys()) {
        final data = dbKv.get(key);
        if (data != null) {
          backup["shared_preferences"][key] = data;
        }
      }
      const serializer = ValueSerializer.defaults(serializeDateTimeValuesAsString: true);
      final db = ref.read(dbSqlProvider);
      backup["drift_schema_version"] = db.schemaVersion;
      for (final (table, _) in _tablesToBackup(db)) {
        final List<DataClass> data = (await db.select(table).get()).cast();
        backup[table.actualTableName] = data.map((e) => e.toJson(serializer: serializer)).toList();
      }
      await FilePicker.platform.saveFile(
        fileName: _exportFilename(DateTime.now()),
        allowedExtensions: ["json"],
        bytes: utf8.encode(const JsonEncoder.withIndent("  ").convert(backup)),
      );
      state = const IdleBackupState();
    } catch (e) {
      state = const ExportErroredBackupState();
      rethrow;
    }
  }

  Future<void> import({bool onConflictUpdate = true}) async {
    try {
      state = const ImportingBackupState();
      final picked = await FilePicker.platform.pickFiles(
        allowedExtensions: ["json"],
        type: FileType.custom,
      );
      if (picked?.files.single.path == null) {
        state = const IdleBackupState();
        return;
      }
      final import = jsonDecode(await File(picked!.files.single.path!).readAsString());
      final sharedPreferences = import["shared_preferences"] as Map?;
      if (sharedPreferences?.isNotEmpty ?? false) {
        final dbKv = ref.read(dbKvProvider);
        for (final entry in sharedPreferences!.entries) {
          switch (entry.value) {
            case final String value:
              dbKv.setString(entry.key, value);
            case final List<String> value:
              dbKv.setStringList(entry.key, value);
            case final bool value:
              dbKv.setBool(entry.key, value);
            case final double value:
              dbKv.setDouble(entry.key, value);
            case final int value:
              dbKv.setInt(entry.key, value);
          }
        }
      }
      // TODO: do migration if needed
      // backup["drift_schema_version"] = db.schemaVersion;
      final db = ref.read(dbSqlProvider);
      await db.batch((batch) {
        for (final (table, fromJson) in _tablesToBackup(db)) {
          final tableImport = import[table.actualTableName] as List?;
          if (tableImport?.isNotEmpty ?? false) {
            if (onConflictUpdate) {
              batch.insertAllOnConflictUpdate(table, tableImport!.cast<Map>().map((e) => fromJson(e.cast<String, dynamic>())));
            } else {
              batch.insertAll(
                table,
                tableImport!.cast<Map>().map((e) => fromJson(e.cast<String, dynamic>())),
                mode: InsertMode.insertOrIgnore,
              );
            }
          }
        }
      });
      state = const IdleBackupState();
    } catch (e) {
      state = const ImportErroredBackupState();
      rethrow;
    }
  }
}

sealed class BackupState extends Equatable {
  const BackupState();

  @override
  List<Object?> get props => [];
}

class IdleBackupState extends BackupState {
  const IdleBackupState();
}

class ExportingBackupState extends BackupState {
  const ExportingBackupState();
}

class ExportErroredBackupState extends BackupState {
  const ExportErroredBackupState();
}

class ImportingBackupState extends BackupState {
  const ImportingBackupState();
}

class ImportErroredBackupState extends BackupState {
  const ImportErroredBackupState();
}
