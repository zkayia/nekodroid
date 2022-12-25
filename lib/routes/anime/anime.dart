
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/constants/player_type.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/extensions/datetime.dart';
import 'package:nekodroid/extensions/duration.dart';
import 'package:nekodroid/extensions/iterable.dart';
import 'package:nekodroid/models/player_route_params.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/anime/providers/full_anime_data.dart';
import 'package:nekodroid/routes/anime/providers/blur_thumbs.dart';
import 'package:nekodroid/routes/anime/widgets/anime_page_header.dart';
import 'package:nekodroid/routes/anime/widgets/anime_synopsis.dart';
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
        child: ref.watch(fullAnimeDataProv(animeUrl)).when(
          loading: () => const CircularProgressIndicator(),
          error: (err, stackTrace) => const LargeIcon(Boxicons.bxs_error_circle),
          data: (data) {
            final headers = [
              AnimePageHeader(data.anime),
              ChipWrap(
                genres: [
                  for (final genre in data.anime.genres)
                    GenericChip.click(
                      label: context.tr.genres(genre.name),
                      onTap: () {}, //TODO: open all anime with this genre
                    ),
                ],
              ),
              AnimeSynopsis(data.anime.synopsis),
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
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final latest = data.isarAnime?.episodeStatuses.reduce(
                        (v, e) => (v.lastExitTimestamp ?? 1) > (e.lastExitTimestamp ?? 0)
                          ? v
                          : e,
                      );
                      final currentIndex = latest?.watchedOnLastExit ?? false
                        ? latest?.episodeNumber ?? 0
                        : (latest?.episodeNumber ?? 1) - 1;
                      navigator.pushNamed(
                        "/player",
                        arguments: PlayerRouteParams(
                          playerType: PlayerType.native,
                          episode: data.anime.episodes.elementAt(currentIndex),
                          anime: data.anime,
                          currentIndex: currentIndex,
                        ),
                      );
                    },
                    child: const Icon(Boxicons.bx_play),
                  ),
                ],
              ),
            ];
            final realItemsCount = data.anime.episodes.length + headers.length;
            return RefreshIndicator(
              onRefresh: () async => ref.refresh(fullAnimeDataProv(animeUrl)),
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  top: kPaddingSecond,
                  left: kPaddingSecond,
                  right: kPaddingSecond,
                  bottom: kPaddingSecond + kFabSize + 16,
                ),
                physics: kDefaultScrollPhysics,
                itemCount: realItemsCount * 2 - 1,
                semanticChildCount: realItemsCount,
                cacheExtent: (kAnimeListTileMaxHeight + kPaddingSecond)
                  * ref.watch(settingsProv.select((v) => v.anime.episodeCacheExtent)),
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                addSemanticIndexes: false,
                itemBuilder: (context, index) {
                  final realIndex = index ~/ 2;
                  if (index.isOdd) {
                    return SizedBox(
                      height: realIndex < headers.length
                        ? kPaddingMain
                        : kPaddingSecond,
                    );
                  }
                  if (realIndex < headers.length) {
                    final header = IndexedSemantics(
                      index: realIndex,
                      child: RepaintBoundary(
                        child: headers.elementAt(realIndex),
                      ),
                    );
                    return realIndex == 0
                      ? KeepAlive(
                        keepAlive: true,
                        child: header,
                      )
                      : header;
                  }
                  final epIndex = realIndex - headers.length;
                  final episode = data.anime.episodes.elementAt(epIndex);
                  void openPlayer(BuildContext context, PlayerType playerType) =>
                    Navigator.of(context).pushNamed(
                      "/player",
                      arguments: PlayerRouteParams(
                        playerType: playerType,
                        episode: episode,
                        anime: data.anime,
                        currentIndex: epIndex,
                      ),
                    );
                  final isarEp = data.isarAnime?.episodeStatuses.firstWhereOrNull(
                    (e) => e.url == episode.url.toString(),
                  );
                  return KeepAlive(
                    keepAlive: ref.watch(settingsProv.select((v) => v.anime.keepEpisodesAlive)),
                    child: IndexedSemantics(
                      index: realIndex,
                      child: RepaintBoundary(
                        child: AnimeListTile(
                          leading: EpisodeThumbnail(
                            episode.thumbnail,
                            watchedFraction: isarEp?.watchedFraction,
                          ),
                          title: context.tr.episodeLong(episode.episodeNumber),
                          titleWrap: false,
                          subtitle: [
                            episode.duration?.toUnitsString(unitsTranslations: context.tr)
                              ?? context.tr.animeUnknownEpDuration,
                            if (
                              isarEp?.lastPosition != null
                              && isarEp?.lastExitDateTime != null
                              && isarEp?.watchedOnLastExit != true
                            )
                              ...[
                                if (isarEp?.lastPositionDuration != null)
                                context.tr.watchedUpTo(
                                  isarEp?.lastPositionDuration?.prettyToString() ?? "",
                                ),
                                isarEp?.lastExitDateTime?.formatHistory(context),
                              ]
                            else
                              isarEp?.lastWatchedDateTime?.completedOn(context), 
                          ].whereType<String>().join("\n"),
                          onTap: () => openPlayer(context, PlayerType.native),
                          onLongPress: () => openPlayer(context, PlayerType.webview),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
