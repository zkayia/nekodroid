
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/app_localizations.dart';
import 'package:nekodroid/extensions/datetime.dart';
import 'package:nekodroid/helpers/anime_data_text.dart';
import 'package:nekodroid/provider/favorites.dart';
import 'package:nekodroid/provider/anime.dart';
import 'package:nekodroid/routes/base/widgets/anime_listview.dart';
import 'package:nekodroid/widgets/anime_card.dart';
import 'package:nekodroid/widgets/anime_list_tile.dart';
import 'package:nekodroid/widgets/generic_button.dart';
import 'package:nekodroid/widgets/generic_cached_image.dart';
import 'package:nekodroid/widgets/labelled_icon.dart';
import 'package:nekodroid/widgets/large_icon.dart';
import 'package:nekosama_dart/nekosama_dart.dart';


class LibraryTabview extends ConsumerWidget {

  const LibraryTabview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = [...ref.watch(favoritesProvider).entries]
      ..sort((a, b) => b.value.compareTo(a.value));
    return TabBarView(
      physics: kDefaultScrollPhysics,
      children: [
        ValueListenableBuilder(
          valueListenable: Hive.box<String>("recent-history").listenable(),
          builder: (context, Box<String> box, child) => AnimeListview(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final reverseIndex = box.length - 1 - index;
              final episode = NSEpisode.fromJson(box.getAt(reverseIndex)!);
              return ref.watch(animeProvider(episode.animeUrl)).when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stackTrace) => const Center(child: Icon(Boxicons.bxs_error_circle)),
                data: (data) => AnimeListTile(
                  title: data.title,
                  subtitle: DateTime.fromMillisecondsSinceEpoch(
                    // will break on: `2106-02-07 07:28:15.000`
                    box.keyAt(reverseIndex) * 1000,
                  ).formatHistory(context),
                  leading: AnimeCard(
                    image: GenericCachedImage(data.thumbnail),
                    badge: context.tr.episodeShort(episode.episodeNumber),
                    onImageTap: () =>
                      Navigator.of(context).pushNamed("/anime", arguments: data.url),
                  ),
                  onTap: () {}, //TODO: open detailled history page
                ),
              );
            },
            placeholder: LabelledIcon.vertical(
              icon: const LargeIcon(Boxicons.bx_history),
              label: context.tr.libraryEmptyHistory,
            ),
          ),
        ),
        AnimeListview(
          itemCount: favorites.length,
          itemBuilder: (context, index) => ref.watch(
            animeProvider(favorites.elementAt(index).key),
          ).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stackTrace) => const Center(child: Icon(Boxicons.bxs_error_circle)),
            data: (anime) => AnimeListTile(
              title: anime.title,
              subtitle: animeDataText(context, anime),
              leading: AnimeCard(image: GenericCachedImage(anime.thumbnail)),
              trailing: GenericButton.elevated(
                onPressed: () => ref.read(favoritesProvider.notifier).toggleFavBoxOnly(
                  anime.url,
                  DateTime.now(),
                  anime,
                ),
                child: ref.watch(favoritesProvider.notifier).isFavoritedBox(anime.url)
                  ? const Icon(
                    Boxicons.bxs_heart,
                    color: Colors.red,
                  )
                  : const Icon(Boxicons.bx_heart),
              ),
              onTap: () =>
                Navigator.of(context).pushNamed("/anime", arguments: anime.url),
            ),
          ),
          onRefresh: () async => ref.refresh(favoritesProvider),
          placeholder: LabelledIcon.vertical(
            icon: const LargeIcon(Boxicons.bx_heart),
            label: context.tr.libraryEmptyFavorites,
          ),
        ),
      ],
    );
  }
}
