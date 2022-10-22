
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/provider/api.dart';
import 'package:nekodroid/schemas/isar_anime_list_item.dart';
import 'package:nekosama/nekosama.dart';


final animeProv = FutureProvider.autoDispose.family<
  MapEntry<NSAnime, IsarAnimeListItem?>,
  Uri
>(
  (ref, url) async {
    final isarAnime = await Isar.getInstance()!.isarAnimeListItems.getByUrl(url.toString());
    await isarAnime?.episodeStatuses.load();
    return MapEntry(
      await ref.watch(apiProv).getAnime(url),
      isarAnime,
    );
  },
);
