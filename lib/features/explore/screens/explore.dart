import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:nekodroid/core/widgets/sliver_scaffold.dart';
import 'package:nekodroid/features/explore/logic/home.dart';
import 'package:nekodroid/features/explore/widgets/anime_tile.dart';
import 'package:nekodroid/features/explore/widgets/carousel.dart';
import 'package:nekodroid/features/explore/widgets/new_episode_tile.dart';
import 'package:nekodroid/features/explore/widgets/section_title.dart';
import 'package:flutter/material.dart' hide CarouselView;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverScaffold(
        noSafeArea: true,
        title: const Text("Explorer"),
        actions: [
          IconButton(
            onPressed: () => context.push("/search"),
            icon: const Icon(Symbols.search_rounded),
          ),
        ],
        body: ref.watch(homeProvider).when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(child: Text(error.toString())),
              data: (data) => RefreshIndicator(
                onRefresh: () => ref.refresh(homeProvider.future),
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    final episodeCarouselHeight =
                        orientation == Orientation.portrait ? context.mq.size.height / 6 : context.mq.size.height / 3;
                    final animeCarouselHeight =
                        orientation == Orientation.portrait ? context.mq.size.height / 4 : context.mq.size.height / 2;
                    final animeCarouselItemWidth = animeCarouselHeight * 5 / 7;
                    return ListView(
                      padding: const EdgeInsets.all(kPadding),
                      children: [
                        SectionTitle(
                          title: "Derniers épisodes",
                          onTap: () => context.push("/explore/latest_episodes"),
                        ),
                        LimitedBox(
                          maxHeight: episodeCarouselHeight,
                          child: CarouselView(
                            itemExtent: episodeCarouselHeight * 16 / 9,
                            shape: kRoundedRecShape,
                            children: [...data.newEpisodes.map(NewEpisodeTile.new)],
                          ),
                        ),
                        const SizedBox(height: kPadding),
                        SectionTitle(
                          title: "Animes saisoniers",
                          onTap: () => context.push("/explore/seasonal_animes"),
                        ),
                        LimitedBox(
                          maxHeight: animeCarouselHeight,
                          child: CarouselView(
                            itemExtent: animeCarouselItemWidth,
                            shape: kRoundedRecShape,
                            children: [...data.seasonalAnimes.map(AnimeTile.new)],
                          ),
                        ),
                        const SizedBox(height: kPadding),
                        SectionTitle(
                          title: "Animes populaires",
                          onTap: () => context.push("/explore/popular_animes"),
                        ),
                        LimitedBox(
                          maxHeight: animeCarouselHeight,
                          child: CarouselView(
                            itemExtent: animeCarouselItemWidth,
                            shape: kRoundedRecShape,
                            children: [...data.mostPopularAnimes.map(AnimeTile.new)],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
      );
}
