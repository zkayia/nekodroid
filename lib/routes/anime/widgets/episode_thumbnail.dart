
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/anime/providers/blur_thumbs.dart';
import 'package:nekodroid/widgets/generic_image.dart';


class EpisodeThumbnail extends ConsumerWidget {

  final Uri imageUrl;
  final double? watchedFraction;
  
  const EpisodeThumbnail(
    this.imageUrl,
    {
      this.watchedFraction,
      super.key,
    }
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbnail = GenericImage(
      imageUrl,
      cacheHeight: kAnimeListTileMaxHeight,
      cacheWidth: kAnimeListTileMaxHeight * 16 / 9,
      childBuilder: (context, child) {
        final blurThumbsSigma = ref.watch(
          settingsProv.select((v) => v.anime.blurThumbsSigma),
        ).toDouble();
        return ref.read(blurThumbsProv)
          ? ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: blurThumbsSigma,
              sigmaY: blurThumbsSigma,
            ),
            child: child,
          )
          : child;
      },
    );
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kBorderRadMain),
        child: watchedFraction == null
          ? thumbnail
          : Stack(
            fit: StackFit.expand,
            children: [
              thumbnail,
              Align(
                alignment: Alignment.bottomLeft,
                child: Material(
                  color: Theme.of(context).colorScheme.primary,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxWidth = constraints.maxWidth == double.infinity
                        ? (
                          constraints.maxHeight == double.infinity
                            ? kAnimeListTileMaxHeight
                            : constraints.maxHeight
                        ) * 16 / 9
                        : constraints.maxWidth;
                      return SizedBox(
                        height: 4,
                        width: watchedFraction! * maxWidth,
                      );
                    },
                  ),
                ),
              )
            ],
          ),
      ),
    );
  }
}
