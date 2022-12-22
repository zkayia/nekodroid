
import 'package:async/async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/models/full_anime_data.dart';
import 'package:nekodroid/provider/api.dart';
import 'package:nekodroid/schemas/isar_anime_list_item.dart';
import 'package:nekodroid/schemas/isar_episode_status.dart';


final fullAnimeDataProv = StreamProvider.autoDispose.family<FullAnimeData, Uri>(
  (ref, url) async* {
    final anime = await ref.watch(apiProv).getAnime(url);
    final isar = Isar.getInstance()!;
    final initialIsarAnime = await isar.isarAnimeListItems.getByUrl(url.toString());
    await initialIsarAnime?.episodeStatuses.load();
    yield FullAnimeData(anime: anime, isarAnime: initialIsarAnime);
    if (initialIsarAnime != null) {
      final updatesGroup = StreamGroup();
      ref.onDispose(updatesGroup.close);
      updatesGroup.add(isar.isarAnimeListItems.watchObjectLazy(initialIsarAnime.id));
      final epIdsInGroup = <int>[];
      for (final ep in initialIsarAnime.episodeStatuses) {
        updatesGroup.add(isar.isarEpisodeStatus.watchObjectLazy(ep.id));
        epIdsInGroup.add(ep.id);
      }
      await for (final _ in updatesGroup.stream) {
        final isarAnime = await isar.isarAnimeListItems.get(initialIsarAnime.id);
        await isarAnime?.episodeStatuses.load();
        for (final ep in isarAnime?.episodeStatuses ?? const {}) {
          if (!epIdsInGroup.contains(ep.id)) {
            updatesGroup.add(isar.isarEpisodeStatus.watchObjectLazy(ep.id));
            epIdsInGroup.add(ep.id);
          }
        }
        yield FullAnimeData(anime: anime, isarAnime: isarAnime);
      }
      updatesGroup.close();
    }
  },
);
