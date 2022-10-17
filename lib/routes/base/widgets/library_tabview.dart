
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
import 'package:nekodroid/routes/base/widgets/anime_listview.dart';
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
          data: (data) => AnimeListview(
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
                      onTap: () {}, //TODO: open detailled history page
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
          data: (data) => AnimeListview(
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
        error: (_, __) => const [
          LabelledIcon.vertical(
            icon: LargeIcon(Boxicons.bx_error_circle),
            label: "Error loading lists", //TODO: tr
          ),
        ],
        loading: () => const [
          LabelledIcon.vertical(
            icon: CircularProgressIndicator(),
            label: "Loading lists", //TODO: tr
          ),
        ],
        data: (data) => data.isEmpty
          ? [
            Center(
              child: GenericButton.elevated(
                onPressed: () {}, //TODO: go to list settings 
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: kPaddingMain,
                    vertical: kPaddingSecond,
                  ),
                  child: LabelledIcon.vertical(
                    icon: Icon(Boxicons.bx_cog),
                    label: "Create a list", //TODO: tr
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
                return AnimeListview(
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
                  placeholder: const LabelledIcon.vertical(
                    icon: Icon(Boxicons.bx_question_mark),
                    label: "List is empty", //TODO: tr
                  ),
                );
              },
            ),
          ),
      ),
    ],
  );
}
