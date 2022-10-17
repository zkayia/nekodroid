
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/schemas/isar_anime_list.dart';


final listsProvider = StreamProvider<List<IsarAnimeList>>(
  (ref) {
    final isar = Isar.getInstance()!;
    return isar.isarAnimeLists.buildQuery<IsarAnimeList>(
      sortBy: const [
        SortProperty(property: "position", sort: Sort.asc),
      ],
    ).watch(fireImmediately: true);
  },
);
