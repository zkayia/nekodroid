
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/extensions/datetime.dart';
import 'package:nekodroid/provider/favorites.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/provider/lists.dart';
import 'package:nekodroid/routes/base/providers/recent_history.dart';
import 'package:nekodroid/widgets/anime_list_view.dart';
import 'package:nekodroid/widgets/anime_card.dart';
import 'package:nekodroid/widgets/anime_list_tile.dart';
import 'package:nekodroid/widgets/generic_button.dart';
import 'package:nekodroid/widgets/generic_cached_image.dart';
import 'package:nekodroid/widgets/labelled_icon.dart';
import 'package:nekodroid/widgets/large_icon.dart';


class LibraryTabview extends ConsumerWidget {

  const LibraryTabview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => TabBarView(
    physics: kDefaultScrollPhysics,
    children: [
      if (ref.watch(settingsProv.select((v) => v.library.enableHistory)))
        ref.watch(recentHistoryProv).when(
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const LargeIcon(Boxicons.bxs_error_circle),
          data: (data) => AnimeListView(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final episode = data.elementAt(index);
              return FutureBuilder(
                future: episode.anime.load(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Icon(Boxicons.bxs_error_circle);
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AnimeListTile(
                      title: episode.anime.value!.title,
                      subtitle: DateTime.fromMillisecondsSinceEpoch(
                        episode.lastWatchedTimestamp!,
                      ).formatHistory(context),
                      leading: AnimeCard(
                        image: GenericCachedImage(episode.thumbnailUri),
                        badge: context.tr.episodeShort(episode.episodeNumber),
                        onTap: () => Navigator.of(context).pushNamed(
                          "/anime",
                          arguments: episode.anime.value!.urlUri,
                        ),
                      ),
                      onTap: () => Navigator.of(context).pushNamed(
                        "/base/detailled_history",
                        arguments: episode.anime.value!,
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              );
            },
            placeholder: LabelledIcon.vertical(
              icon: const LargeIcon(Boxicons.bx_history),
              label: context.tr.libraryEmptyHistory,
            ),
          ),
        ),
      if (ref.watch(settingsProv.select((v) => v.library.enableFavorites)))
        ref.watch(favoritesProv).when(
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const LargeIcon(Boxicons.bxs_error_circle),
          data: (data) => AnimeListView(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final anime = data.elementAt(index);
              return AnimeListTile(
                title: anime.title,
                subtitle: anime.dataText(context),
                leading: AnimeCard(image: GenericCachedImage(anime.thumbnailUri)),
                onTap: () => Navigator.of(context).pushNamed(
                  "/anime",
                  arguments: anime.urlUri,
                ),
              );
            },
            placeholder: LabelledIcon.vertical(
              icon: const LargeIcon(Boxicons.bx_heart),
              label: context.tr.libraryEmptyFavorites,
            ),
          ),
        ),
      ...ref.watch(listsProv).when(
        error: (_, __) => [
          LabelledIcon.vertical(
            icon: const LargeIcon(Boxicons.bx_error_circle),
            label: context.tr.errorLoadingLists,
          ),
        ],
        loading: () => [
          LabelledIcon.vertical(
            icon: const CircularProgressIndicator(),
            label: context.tr.loadingLists,
          ),
        ],
        data: (data) => data.isEmpty
          ? [
            Center(
              child: GenericButton.elevated(
                onPressed: () =>
                  Navigator.of(context).pushNamed("/settings/library/lists"),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kPaddingMain,
                    vertical: kPaddingSecond,
                  ),
                  child: LabelledIcon.horizontal(
                    icon: const Icon(Boxicons.bx_plus),
                    label: context.tr.createNewList,
                    minMainAxis: true,
                  ),
                ),
              ),
            ),
          ]
          : data.map(
            (e) => FutureBuilder(
              future: e.animes.load(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snap.hasError) {
                  return const Icon(Boxicons.bx_error_circle);
                }
                return AnimeListView(
                  itemCount: e.animes.length,
                  itemBuilder: (context, index) {
                    final anime = e.animes.elementAt(index);
                    return AnimeListTile(
                      title: anime.title,
                      subtitle: anime.dataText(context),
                      leading: AnimeCard(image: GenericCachedImage(anime.thumbnailUri)),
                      onTap: () => Navigator.of(context).pushNamed(
                        "/anime",
                        arguments: anime.urlUri,
                      ),
                    );
                  },
                  placeholder: LabelledIcon.vertical(
                    icon: const LargeIcon(Boxicons.bx_question_mark),
                    label: context.tr.emptyList,
                  ),
                );
              },
            ),
          ),
      ),
    ],
  );
}
