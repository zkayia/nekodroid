
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/schemas/isar_anime_list_item.dart';


final favoritesProv = StreamProvider.autoDispose<List<IsarAnimeListItem>>(
  (ref) => Isar.getInstance()!.isarAnimeListItems.filter()
    .favoritedTimestampIsNotNull()
    .sortByFavoritedTimestampDesc()
    .watch(fireImmediately: true),
);
