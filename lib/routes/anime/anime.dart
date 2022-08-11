
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/app_localizations.dart';
import 'package:nekodroid/extensions/datetime.dart';
import 'package:nekodroid/provider/history.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/provider/anime.dart';
import 'package:nekodroid/routes/anime/providers/blur_thumbs.dart';
import 'package:nekodroid/routes/anime/widgets/anime_page_header.dart';
import 'package:nekodroid/routes/anime/widgets/episode_thumbnail.dart';
import 'package:nekodroid/routes/player/player.dart';
import 'package:nekodroid/widgets/anime_list_tile.dart';
import 'package:nekodroid/widgets/genre_chip.dart';
import 'package:nekodroid/widgets/genre_grid.dart';
import 'package:nekodroid/widgets/generic_route.dart';
import 'package:nekodroid/widgets/large_icon.dart';


/* CONSTANTS */




/* MODELS */




/* PROVIDERS */

final lazyLoadProvider = StateProvider.autoDispose<int>(
	(ref) => ref.watch(settingsProvider.select((v) => v.lazyLoadItemCount)),
);


/* MISC */




/* WIDGETS */

class AnimeRoute extends ConsumerWidget {

	const AnimeRoute({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final animeUrl = ModalRoute.of(context)!.settings.arguments as Uri;
		return GenericRoute(
			body: Center(
				child: ref.watch(animeProvider(animeUrl)).when(
					loading: () => const CircularProgressIndicator(),
					error: (err, stackTrace) => const LargeIcon(Boxicons.bxs_error_circle),
					data: (data) {
						final synopsis = Hero(
							tag: "anime_description",
							child: Text(
								data.synopsis ?? context.tr.animeNoSynopsis,
								textAlign: TextAlign.justify,
								style: Theme.of(context).textTheme.bodyMedium,
							),
						);
						final history = ref.watch(historyProvider).get(data.url.toString()) ?? {};
						return LazyLoadScrollView(
							onEndOfPage: () => ref.read(lazyLoadProvider.notifier).update(
								(state) => (
									state + ref.watch(settingsProvider).lazyLoadItemCount
								).clamp(0, data.episodes.length),
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
										AnimePageHeader(data),
										const SizedBox(height: kPaddingSecond),
										GenreGrid(
											genres: [
												for (final genre in data.genres)
													GenreChip.click(
														label: context.tr.genres(genre.name),
														onTap: () {},  //TODO: open all anime with this genre
													),
											],
										),
										const SizedBox(height: kPaddingSecond),
										LimitedBox(
											maxHeight: kAnimePageGroupMaxHeight,
											child: TextButton(
												onPressed: data.synopsis == null
													? null
													: () => Navigator.of(context).pushNamed(
														"/fullscreen_viewer",
														arguments: synopsis,
													),
												style: const ButtonStyle().copyWith(
													backgroundColor: MaterialStateProperty.all(
														Theme.of(context).scaffoldBackgroundColor,
													),
												),
												child: synopsis,
											),
										),
										if (ref.watch(settingsProvider.select((value) => value.blurThumbsShowSwitch)))
											SwitchListTile(
												title: Text(context.tr.blurThumbs),
												value: ref.watch(blurThumbsProvider),
												onChanged: (bool value) =>
													ref.read(blurThumbsProvider.notifier).update((state) => value),
											),
										const SizedBox(height: kPaddingMain),
										ListView.separated(
											shrinkWrap: true,
											physics: const NeverScrollableScrollPhysics(),
											itemCount: ref.watch(lazyLoadProvider),
											separatorBuilder: (context, index) => const SizedBox(height: kPaddingSecond),
											itemBuilder: (context, index) {
												final episode = data.episodes.elementAt(index);
												void openPlayer(PlayerType playerType) => Navigator.of(context).pushNamed(
													"/player",
													arguments: PlayerRouteParameters(
														playerType: playerType,
														episode: episode,
														anime: data,
														currentIndex: index,
													),
												);
												final wasWatched = history.containsKey(episode.episodeNumber);
												return AnimeListTile(
													leading: EpisodeThumbnail(episode.thumbnail),
													trailing: Checkbox(
														value: wasWatched,
														onChanged: (value) async => ref.read(historyProvider.notifier).toggleEntry(
															data.toJson(),
															episode,
															DateTime.now().millisecondsSinceEpoch,
														),
													),
													title: "Episode ${episode.episodeNumber}",
													titleWrap: false,
													subtitle: "${
														context.tr.minutesShort(episode.duration?.inMinutes ?? 0)
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
