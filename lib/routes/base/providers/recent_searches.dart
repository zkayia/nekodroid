
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/schemas/isar_search_anime.dart';


final recentSearchesProv = FutureProvider.autoDispose.family<List<IsarSearchAnime>, List?>(
  (ref, ids) async {
    if (ids?.isEmpty ?? true) {
      return const [];
    }
    final isar = Isar.getInstance()!;
    return [
      ...(
        await isar.txn(() => isar.isarSearchAnimes.getAll(ids!.cast<int>()))
      ).whereType<IsarSearchAnime>(),
    ];
  }
);
