
import 'package:boxicons/boxicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/helpers/format_history_datetime.dart';
import 'package:nekodroid/provider/history.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/provider/anime.dart';
import 'package:nekodroid/routes/anime/providers/blur_thumbs.dart';
import 'package:nekodroid/routes/anime/providers/lazy_load.dart';
import 'package:nekodroid/routes/anime/widgets/anime_page_header.dart';
import 'package:nekodroid/routes/anime/widgets/episode_thumbnail.dart';
import 'package:nekodroid/widgets/anime_list_tile.dart';
import 'package:nekodroid/widgets/genre_chip.dart';
import 'package:nekodroid/widgets/genre_grid.dart';
import 'package:nekodroid/widgets/generic_route.dart';
import 'package:nekodroid/widgets/large_icon.dart';


class AnimeRoute extends ConsumerWidget {

	const AnimeRoute({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final animeUrl = ModalRoute.of(context)?.settings.arguments as Uri?;
		return GenericRoute(
			body: Center(
				child: ref.watch(animeProvider(animeUrl)).when(
					loading: () => const CircularProgressIndicator(),
					error: (err, stackTrace) => const LargeIcon(Boxicons.bx_error_circle),
					data: (data) {
						final synopsis = Hero(
							tag: "anime_description",
							child: Text(
								data.synopsis ?? "no-synopsis".tr(),
								textAlign: TextAlign.justify,
								style: Theme.of(context).textTheme.bodyMedium,
							),
						);
						final history = ref.watch(historyProvider).get(data.url.toString()) ?? {};
						return LazyLoadScrollView(
							onEndOfPage: () => ref.read(lazyLoadProvider(data.episodes).notifier).loadMore(),
							child: RefreshIndicator(
								onRefresh: () async => ref.refresh(animeProvider(animeUrl)),
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
														label: "genres-list".tr(gender: genre.name),
														onTap: () {},  //TODO: open all anime with this genre
													),
											],
										),
										const SizedBox(height: kPaddingSecond),
										LimitedBox(
											maxHeight: kAnimePageGroupMaxHeight,
											child: TextButton(
												child: synopsis,
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
											),
										),
										if (ref.watch(settingsProvider.select((value) => value.blurThumbsShowSwitch)))
											SwitchListTile(
												title: const Text("blur-thumbs").tr(),
												value: ref.watch(blurThumbsProvider),
												onChanged: (bool value) =>
													ref.read(blurThumbsProvider.notifier).update((state) => value),
											),
										const SizedBox(height: kPaddingMain),
										ListView.separated(
											shrinkWrap: true,
											physics: const NeverScrollableScrollPhysics(),
											itemCount: ref.watch(lazyLoadProvider(data.episodes)).length,
											separatorBuilder: (context, index) => const SizedBox(height: kPaddingSecond),
											itemBuilder: (context, index) {
												final episode = ref.read(lazyLoadProvider(data.episodes)).elementAt(index);
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
														"minutes.short".plural(episode.duration?.inMinutes ?? 0)
													}${
														wasWatched
															? formatHistoryDatetime(
																DateTime.fromMillisecondsSinceEpoch(
																	history[episode.episodeNumber] ?? 0,
																),
															)
															: ""
													}",
													onTap: () => Navigator.of(context).pushNamed(
														"/player",
														arguments: episode,
													),
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
