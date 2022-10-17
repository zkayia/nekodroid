
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/base.search/providers/query.dart';
import 'package:nekodroid/schemas/isar_search_anime.dart';


final searchResultsProv = FutureProvider.autoDispose<List<IsarSearchAnime>>(
  (ref) {
    final query = ref.watch(queryProv);
    final isar = Isar.getInstance()!;
    if (query == null) {
      if (ref.watch(settingsProv.select((v) => v.search.showAllWhenNoQuery))) {
        return isar.txn(
          isar.isarSearchAnimes.buildQuery<IsarSearchAnime>(
            sortBy: const [
              SortProperty(
                property: "popularity",
                sort: Sort.desc,
              ),
            ],
          ).findAll,
        );
      }
      return [];
    }
    return isar.txn(query.findAll);
  },
);
