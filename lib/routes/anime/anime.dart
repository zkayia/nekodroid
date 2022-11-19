
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/constants/player_type.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/extensions/datetime.dart';
import 'package:nekodroid/extensions/duration.dart';
import 'package:nekodroid/extensions/iterable.dart';
import 'package:nekodroid/models/player_route_params.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/anime/providers/anime.dart';
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
          data: (animes) {
            final synopsis = Hero(
              tag: "anime_description",
              child: Text(
                animes.key.synopsis ?? context.tr.animeNoSynopsis,
                textAlign: TextAlign.justify,
                style: theme.textTheme.bodyMedium,
              ),
            );
            return LazyLoadScrollView(
              onEndOfPage: () =>
                ref.read(lazyLoadProv(animes.key.episodes.length).notifier).update(
                  (state) => (
                    state + ref.watch(settingsProv).anime.lazyLoadItemCount
                  ).clamp(0, animes.key.episodes.length),
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
                    AnimePageHeader(animes.key),
                    const SizedBox(height: kPaddingMain),
                    ChipWrap(
                      genres: [
                        for (final genre in animes.key.genres)
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
                        onTap: animes.key.synopsis == null
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
                          context.tr.episodes,
                          style: theme.textTheme.titleLarge,
                        ),
                        GenericButton.elevated(
                          onPressed: () {
                            final latest = (
                              animes.value?.episodeStatuses.reduce(
                                (v, e) => v.episodeNumber > e.episodeNumber ? v : e,
                              ).episodeNumber ?? 1
                            ) - 1;
                            Navigator.of(context).pushNamed(
                              "/player",
                              arguments: PlayerRouteParams(
                                playerType: PlayerType.native,
                                episode: animes.key.episodes.elementAt(latest),
                                anime: animes.key,
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
                      itemCount: ref.watch(lazyLoadProv(animes.key.episodes.length)),
                      separatorBuilder: (context, index) => const SizedBox(height: kPaddingSecond),
                      itemBuilder: (context, index) {
                        final episode = animes.key.episodes.elementAt(index);
                        void openPlayer(PlayerType playerType) => Navigator.of(context).pushNamed(
                          "/player",
                          arguments: PlayerRouteParams(
                            playerType: playerType,
                            episode: episode,
                            anime: animes.key,
                            currentIndex: index,
                          ),
                        );
                        // TODO: refresh when anime or ep changes
                        final isarEp = animes.value?.episodeStatuses.firstWhereOrNull(
                          (e) => e.url == episode.url.toString(),
                        );
                        return AnimeListTile(
                          leading: EpisodeThumbnail(
                            episode.thumbnail,
                            watchedFraction: isarEp?.watchedFraction,
                          ),
                          title: context.tr.episodeLong(episode.episodeNumber),
                          titleWrap: false,
                          subtitle: "${
                            episode.duration?.toUnitsString(unitsTranslations: context.tr)
                              ?? context.tr.animeUnknownEpDuration
                          }${
                            isarEp?.lastWatchedTimestamp != null
                              ? "\n${
                                DateTime.fromMillisecondsSinceEpoch(
                                  isarEp!.lastWatchedTimestamp!,
                                ).formatHistory(context)
                              }"
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
