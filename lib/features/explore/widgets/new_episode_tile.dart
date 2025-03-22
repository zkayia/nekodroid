import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/extensions/list.dart';
import 'package:nekodroid/core/extensions/uri.dart';
import 'package:nekodroid/core/widgets/cached_rounded_network_image.dart';
import 'package:nekodroid/features/explore/widgets/custom_grid_tile_bar.dart';
import 'package:nekodroid/features/player/data/player_route_params.dart';
import 'package:nekosama/nekosama.dart';

class NewEpisodeTile extends StatelessWidget {
  final NSNewEpisode episode;

  const NewEpisodeTile(this.episode, {super.key});

  @override
  Widget build(BuildContext context) {
    final addedAgo = DateTime.now().difference(episode.addedAt).inMinutes.abs();
    return GestureDetector(
      onTap: () => context.push(
        "/player",
        extra: PlayerRouteParams(
          episode: episode,
          title: episode.title,
          animeUrl: episode.animeUrl,
        ),
      ),
      onLongPress: () => context.push("/anime/${episode.animeUrl.encoded}"),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CachedRoundedNetworkImage(episode.thumbnail.toString()),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(kPadding / 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (final icon in episode.icons)
                    Material(
                      borderRadius: const BorderRadius.all(Radius.circular(kBorderRad - kPadding / 2)),
                      color: Color(icon.hexColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: kPadding / 2),
                        child: Text(icon.displayName.toUpperCase()),
                      ),
                    ),
                ].withSeparator(const SizedBox(width: kPadding / 4)),
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: CustomGridTileBar(
              title: Text(episode.title),
              subtitle: Text(
                "${switch (addedAgo) {
                  >= 24 * 60 => "Il y a ${addedAgo ~/ (24 * 60)} jours",
                  >= 60 => "Il y a ${addedAgo ~/ 60} heures",
                  >= 1 => "Il y a $addedAgo minutes",
                  _ => "Maintenant",
                }} • Ep ${episode.episodeNumber}",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
