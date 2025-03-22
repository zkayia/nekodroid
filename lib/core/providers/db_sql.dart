import 'package:nekodroid/core/database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_sql.g.dart';

@Riverpod(keepAlive: true)
AppDatabase dbSql(DbSqlRef ref) => AppDatabase();
