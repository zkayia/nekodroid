import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:nekodroid/core/extensions/string.dart';
import 'package:nekodroid/core/extensions/uri.dart';
import 'package:nekodroid/core/widgets/cached_rounded_network_image.dart';

class SearchAnimeTile extends StatelessWidget {
  final SearchAnime anime;

  const SearchAnimeTile(this.anime, {super.key});

  static const double _searchAnimeTileHeight = 120;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: _searchAnimeTileHeight),
        child: InkWell(
          borderRadius: kBorderRadCirc,
          onTap: () => context.push("/anime/${anime.url.encoded}"),
          child: Padding(
            padding: const EdgeInsets.all(kPadding / 2),
            child: Row(
              children: [
                CachedRoundedNetworkImage(
                  anime.thumbnail.toString(),
                  height: _searchAnimeTileHeight - kPadding,
                  width: (_searchAnimeTileHeight - kPadding) * 5 / 7,
                ),
                const SizedBox(width: kPadding),
                Expanded(
                  child: DefaultTextStyle(
                    style: context.th.textTheme.labelLarge ?? context.defTextStyle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          anime.title,
                          style: context.th.textTheme.titleMedium,
                          maxLines: 3,
                        ),
                        Text(
                          [
                            anime.type.displayName.toTitleCase(),
                            "${anime.episodeCount ?? "?"} Eps",
                            anime.status.displayName.toTitleCase(),
                          ].join(" • "),
                        ),
                        Text(
                          [
                            anime.source.displayName.toUpperCase(),
                            anime.year.toString(),
                          ].join(" • "),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
