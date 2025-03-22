import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/extensions/uri.dart';
import 'package:nekodroid/core/widgets/cached_rounded_network_image.dart';
import 'package:nekodroid/features/explore/widgets/custom_grid_tile_bar.dart';

class LibraryTile extends StatelessWidget {
  final Anime anime;

  const LibraryTile(this.anime, {super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.push("/anime/${anime.url.encoded}"),
        child: GridTile(
          footer: CustomGridTileBar(
            title: Text(anime.title),
          ),
          child: CachedRoundedNetworkImage(anime.thumbnail.toString()),
        ),
      );
}
