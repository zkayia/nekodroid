
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/build_context.dart';
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
    onRefresh: () async => ref.refresh(homeProv),
    child: Center(
      child: ref.watch(homeProv).when(
        error: (error, stackTrace) => const LargeIcon(Boxicons.bxs_error_circle),
        loading: () => const CircularProgressIndicator(),
        data: (data) {
          final carousels = <String, List>{
            context.tr.homeLatestEps: data.newEpisodes,
            context.tr.homeSeasonalAnimes: data.seasonalAnimes,
            context.tr.homePopularAnimes: data.mostPopularAnimes,
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
              final isEpisode = index == 0;
              AnimeCard cardBuilder(BuildContext context, element) => AnimeCard(
                image: GenericCachedImage(element.thumbnail),
                isEpisode: isEpisode,
                badge: isEpisode ?
                  context.tr.episodeShort(element.episodeNumber)
                  : null,
                label: isEpisode ? element.episodeTitle : element.title,
                onTap: () => isEpisode
                  ? ref.read(settingsProv).home.episodeCardPressAction
                    .doAction(Navigator.of(context), ref, element)
                  : ref.read(settingsProv).home.animeCardPressAction
                    .doAction(Navigator.of(context), ref, element),
                onLongPress: () => isEpisode
                  ? ref.read(settingsProv).home.episodeCardLongPressAction
                    .doAction(Navigator.of(context), ref, element)
                  : ref.read(settingsProv).home.animeCardLongPressAction
                    .doAction(Navigator.of(context), ref, element),
              );
              return AnimeCarousel(
                onMoreTapped: () => Navigator.of(context).pushNamed(
                  "/base/carousel_more",
                  arguments: CarouselMoreParameters(
                    title: carousel.key,
                    cards: [
                      ...carousel.value.map((e) => cardBuilder(context, e)),
                    ],
                  ),
                ),
                title: carousel.key,
                itemCount: ref.read(settingsProv).home.carouselColumnCount
                  * (index == 0 ? 2 : 1),
                itemBuilder: (context, index) {
                  final element = carousel.value.elementAt(index);
                  return cardBuilder(context, element);
                },
                isEpisode: isEpisode,
              );
            },
          );
        },
      ),
    ),
  );
}
