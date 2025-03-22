import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'db_kv.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences dbKv(DbKvRef ref) {
  throw UnimplementedError();
}
