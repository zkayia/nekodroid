
import 'dart:math';

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/constants/player_type.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/extensions/datetime.dart';
import 'package:nekodroid/extensions/duration.dart';
import 'package:nekodroid/models/player_route_params.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/provider/anime.dart';
import 'package:nekodroid/routes/anime/providers/blur_thumbs.dart';
import 'package:nekodroid/routes/anime/providers/lazy_load.dart';
import 'package:nekodroid/routes/anime/widgets/anime_page_header.dart';
import 'package:nekodroid/routes/anime/widgets/episode_thumbnail.dart';
import 'package:nekodroid/widgets/anime_list_tile.dart';
import 'package:nekodroid/widgets/generic_button.dart';
import 'package:nekodroid/widgets/generic_chip.dart';
import 'package:nekodroid/widgets/chip_wrap.dart';
import 'package:nekodroid/widgets/generic_route.dart';
import 'package:nekodroid/widgets/large_icon.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class AnimeRoute extends ConsumerWidget {

  const AnimeRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animeUrl = ModalRoute.of(context)!.settings.arguments as Uri;
    final theme = Theme.of(context);
    return GenericRoute(
      body: Center(
        child: ref.watch(animeProv(animeUrl)).when(
          loading: () => const CircularProgressIndicator(),
          error: (err, stackTrace) => const LargeIcon(Boxicons.bxs_error_circle),
          data: (anime) {
            final synopsis = Hero(
              tag: "anime_description",
              child: Text(
                anime.synopsis ?? context.tr.animeNoSynopsis,
                textAlign: TextAlign.justify,
                style: theme.textTheme.bodyMedium,
              ),
            );
            final history = {}; //TODO: load history for anime
            return LazyLoadScrollView(
              onEndOfPage: () => ref.read(lazyLoadProv(anime.episodes.length).notifier).update(
                (state) => (
                  state + ref.watch(settingsProv).anime.lazyLoadItemCount
                ).clamp(0, anime.episodes.length),
              ),
              child: RefreshIndicator(
                onRefresh: () async => ref.refresh(animeProv(animeUrl)),
                child: ListView(
                  padding: const EdgeInsets.only(
                    top: kPaddingSecond,
                    left: kPaddingSecond,
                    right: kPaddingSecond,
                    bottom: kPaddingSecond + kFabSize + 16,
                  ),
                  physics: kDefaultScrollPhysics,
                  children: [
                    AnimePageHeader(anime),
                    const SizedBox(height: kPaddingMain),
                    ChipWrap(
                      genres: [
                        for (final genre in anime.genres)
                          GenericChip.click(
                            label: context.tr.genres(genre.name),
                            onTap: () {}, //TODO: open all anime with this genre
                          ),
                      ],
                    ),
                    const SizedBox(height: kPaddingMain),
                    LimitedBox(
                      maxHeight: kAnimePageGroupMaxHeight,
                      child: InkWell(
                        onTap: anime.synopsis == null
                          ? null
                          : () => Navigator.of(context).pushNamed(
                            "/fullscreen_viewer",
                            arguments: synopsis,
                          ),
                        borderRadius: BorderRadius.circular(kBorderRadMain),
                        child: Padding(
                          padding: const EdgeInsets.all(kPaddingSecond / 2),
                          child: synopsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: kPaddingMain),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GenericButton.elevated(
                          onPressed: () => ref.read(blurThumbsProv.notifier).update((s) => !s),
                          primary: ref.watch(blurThumbsProv),
                          primaryOnForeground: true,
                          child: const Icon(Boxicons.bxs_low_vision),
                        ),
                        SingleLineText(
                          "Episodes", //TODO: tr
                          style: theme.textTheme.titleLarge,
                        ),
                        GenericButton.elevated(
                          onPressed: () {
                            final latest = history.isEmpty
                              ? 0
                              : history.keys.cast<int>().reduce(max);
                            Navigator.of(context).pushNamed(
                              "/player",
                              arguments: PlayerRouteParams(
                                playerType: PlayerType.native,
                                episode: anime.episodes.elementAt(latest),
                                anime: anime,
                                currentIndex: latest,
                              ),
                            );
                          },
                          child: const Icon(Boxicons.bx_play),
                        ),
                      ],
                    ),
                    const SizedBox(height: kPaddingMain),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ref.watch(lazyLoadProv(anime.episodes.length)),
                      separatorBuilder: (context, index) => const SizedBox(height: kPaddingSecond),
                      itemBuilder: (context, index) {
                        final episode = anime.episodes.elementAt(index);
                        void openPlayer(PlayerType playerType) => Navigator.of(context).pushNamed(
                          "/player",
                          arguments: PlayerRouteParams(
                            playerType: playerType,
                            episode: episode,
                            anime: anime,
                            currentIndex: index,
                          ),
                        );
                        final wasWatched = history.containsKey(episode.episodeNumber);
                        return AnimeListTile(
                          leading: EpisodeThumbnail(episode.thumbnail),
                          trailing: Checkbox(
                            value: wasWatched,
                            onChanged: (value) async {}, //TODO: toggle ep history
                          ),
                          title: "Episode ${episode.episodeNumber}", //TODO: tr
                          titleWrap: false,
                          subtitle: "${
                            episode.duration?.toUnitsString(unitsTranslations: context.tr)
                              ?? context.tr.animeUnknownEpDuration
                          }${
                            wasWatched
                              ? DateTime.fromMillisecondsSinceEpoch(
                                history[episode.episodeNumber] ?? 0,
                              ).formatHistory(context)
                              : ""
                          }",
                          onTap: () => openPlayer(PlayerType.native),
                          onLongPress: () => openPlayer(PlayerType.webview),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
