
import 'package:boxicons/boxicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/models/carousel_more_parameters.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/base/providers/home.dart';
import 'package:nekodroid/routes/base/widgets/anime_carousel.dart';
import 'package:nekodroid/widgets/anime_card.dart';
import 'package:nekodroid/widgets/generic_cached_image.dart';
import 'package:nekodroid/widgets/large_icon.dart';


class HomePage extends ConsumerWidget {

	const HomePage({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) => RefreshIndicator(
		onRefresh: () async => ref.refresh(homeProvider),
		child: Center(
			child: ref.watch(homeProvider).when(
				error: (error, stackTrace) => const LargeIcon(Boxicons.bxs_error_circle),
				loading: () => const CircularProgressIndicator(),
				data: (data) {
					final carousels = {
						"latest-eps".tr(): _buildAnimeCards(context, data.newEpisodes, true),
						"seasonal-animes".tr(): _buildAnimeCards(context, data.seasonalAnimes),
						"popular-animes".tr(): _buildAnimeCards(context, data.mostPopularAnimes),
					};
					return ListView.separated(
						physics: kDefaultScrollPhysics,
						padding: const EdgeInsets.only(
							top: kPaddingSecond,
							bottom: kPaddingSecond * 2 + kBottomBarHeight,
						),
						itemCount: carousels.keys.length,
						separatorBuilder: (context, index) => const SizedBox(height: kPaddingCarousels),
						itemBuilder: (context, index) {
							final carousel = carousels.entries.elementAt(index);
							return AnimeCarousel(
								onMoreTapped: () => Navigator.of(context).pushNamed(
									"/carousel_more",
									arguments: CarouselMoreParameters(
										title: carousel.key,
										cards: carousel.value,
									),
								),
								title: carousel.key,
								items: [...carousel.value.take(
									ref.read(settingsProvider).carouselItemCount,
								)],
							);
						},
					);
				},
			),
		),
	);

	List<AnimeCard> _buildAnimeCards(
		BuildContext context,
		List elements,
		[
			bool isEpisode=false,
		]
	) => [
		...elements.map(
			(e) => AnimeCard(
				image: GenericCachedImage(e.thumbnail),
				isEpisode: isEpisode,
				badge: isEpisode ?
					"episode.short".tr(args: [e.episodeNumber.toString()])
					: null,
				label: isEpisode ? e.episodeTitle : e.title,
				onImageTap: () => isEpisode
					? Navigator.of(context).pushNamed("/player", arguments: e)
					: Navigator.of(context).pushNamed("/anime", arguments: e.url),
				onLabelTap: () => Navigator.of(context).pushNamed(
					"/anime",
					arguments: isEpisode ? e.animeUrl : e.url,
				),
			),
		),
	];
}
