import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nekodroid/core/extensions/uri.dart';
import 'package:nekodroid/core/widgets/cached_rounded_network_image.dart';
import 'package:nekodroid/features/explore/widgets/custom_grid_tile_bar.dart';
import 'package:nekosama/nekosama.dart';

class AnimeTile extends StatelessWidget {
  final NSCarouselAnime anime;

  const AnimeTile(this.anime, {super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.push("/anime/${anime.url.encoded}"),
        child: GridTile(
          footer: CustomGridTileBar(
            title: Text(anime.title),
            subtitle: Text("${anime.year} • ${anime.episodeCount ?? "?"} Eps"),
          ),
          child: CachedRoundedNetworkImage(anime.thumbnail.toString()),
        ),
      );
}
