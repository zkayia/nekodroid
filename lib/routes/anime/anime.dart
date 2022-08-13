
import 'dart:math';

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/app_localizations.dart';
import 'package:nekodroid/extensions/datetime.dart';
import 'package:nekodroid/extensions/duration.dart';
import 'package:nekodroid/provider/history.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/provider/anime.dart';
import 'package:nekodroid/routes/anime/providers/blur_thumbs.dart';
import 'package:nekodroid/routes/anime/widgets/anime_page_header.dart';
import 'package:nekodroid/routes/anime/widgets/episode_thumbnail.dart';
import 'package:nekodroid/routes/player/player.dart';
import 'package:nekodroid/widgets/anime_list_tile.dart';
import 'package:nekodroid/widgets/generic_button.dart';
import 'package:nekodroid/widgets/genre_chip.dart';
import 'package:nekodroid/widgets/genre_grid.dart';
import 'package:nekodroid/widgets/generic_route.dart';
import 'package:nekodroid/widgets/large_icon.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


/* CONSTANTS */




/* MODELS */




/* PROVIDERS */

final lazyLoadProvider = StateProvider.autoDispose.family<int, int>(
	(ref, total) => ref.watch(
		settingsProvider.select((v) => v.lazyLoadItemCount),
	).clamp(0, total),
);


/* MISC */




/* WIDGETS */

class AnimeRoute extends ConsumerWidget {

	const AnimeRoute({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final animeUrl = ModalRoute.of(context)!.settings.arguments as Uri;
		final theme = Theme.of(context);
		return GenericRoute(
			body: Center(
				child: ref.watch(animeProvider(animeUrl)).when(
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
						final history = ref.watch(historyProvider).get(anime.url.toString()) ?? {};
						return LazyLoadScrollView(
							onEndOfPage: () => ref.read(lazyLoadProvider(anime.episodes.length).notifier).update(
								(state) => (
									state + ref.watch(settingsProvider).lazyLoadItemCount
								).clamp(0, anime.episodes.length),
							),
							child: RefreshIndicator(
								onRefresh: () async {
									final stringUrl = animeUrl.toString();
									final cacheBox = Hive.box<String>("anime-cache");
									await cacheBox.delete(stringUrl);
									ref.refresh(animeProvider(animeUrl)).whenData(
										(value) => cacheBox.put(stringUrl, value.toJson()),
									);
								},
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
										GenreGrid(
											genres: [
												for (final genre in anime.genres)
													GenreChip.click(
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
													onPressed: () =>
														ref.read(blurThumbsProvider.notifier).update((state) => !state),
													primary: ref.watch(blurThumbsProvider),
													primaryOnForeground: true,
													child: const Icon(Boxicons.bxs_low_vision),
												),
												SingleLineText(
													"Episodes",
													style: theme.textTheme.titleLarge,
												),
												GenericButton.elevated(
													onPressed: () {
														final latest = history.isEmpty
															? 0
															: history.keys.cast<int>().reduce(max);
														Navigator.of(context).pushNamed(
															"/player",
															arguments: PlayerRouteParameters(
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
											itemCount: ref.watch(lazyLoadProvider(anime.episodes.length)),
											separatorBuilder: (context, index) => const SizedBox(height: kPaddingSecond),
											itemBuilder: (context, index) {
												final episode = anime.episodes.elementAt(index);
												void openPlayer(PlayerType playerType) => Navigator.of(context).pushNamed(
													"/player",
													arguments: PlayerRouteParameters(
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
														onChanged: (value) async => ref.read(historyProvider.notifier).toggleEntry(
															anime.toJson(),
															episode,
															DateTime.now().millisecondsSinceEpoch,
														),
													),
													title: "Episode ${episode.episodeNumber}",
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
