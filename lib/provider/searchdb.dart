
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/provider/api.dart';
import 'package:nekosama_hive/nekosama_hive.dart';


final searchdbProvider = FutureProvider<NSHiveSearchDb>(
  (ref) async {
    final db = ref.watch(apiProvider).hiveSearchDb;
    await db.init();
    if (
      db.lastPopulated == null
      || (db.lastPopulated?.millisecondsSinceEpoch ?? 0) > kSearchDbMaxLifetime
    ) {
      await db.populate();
    }
    return db;
  },
);
