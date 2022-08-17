
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/provider/api.dart';
import 'package:nekosama_dart/nekosama_dart.dart';


final searchdbProvider = FutureProvider<NSSearchDb>(
  (ref) async {
    final db = ref.watch(apiProvider).searchDb;
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
