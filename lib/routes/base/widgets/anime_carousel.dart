
import 'dart:math';

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class AnimeCarousel extends StatelessWidget {

  final String title;
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Object? titleHeroTag;
  final bool isEpisode;
  final void Function()? onMoreTapped;

  const AnimeCarousel({
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.titleHeroTag,
    this.onMoreTapped,
    this.isEpisode=false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final titleLarge = Theme.of(context).textTheme.titleLarge;
    final titleEl = SingleLineText(
      title,
      style: titleLarge,
    );
    final mediaQuery = MediaQuery.of(context);
    final baseWidth = mediaQuery.size.width - kPaddingMain * 2;
    return LimitedBox(
      maxHeight: max(
        (
          isEpisode
            ? (baseWidth - kPaddingSecond) / 2
              * 10 / 16
              * 2
              + kPaddingSecond
            : (baseWidth - kPaddingSecond * 2) / 3
              * 7 / 5
        ) + (titleLarge?.fontSize ?? 14),
        kAnimeCarouselMinHeight,
      ) * mediaQuery.textScaleFactor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: kPaddingMain / 2,
              right: kPaddingMain / 2,
              bottom: kPaddingSecond,
            ),
            child: InkWell(
              onTap: onMoreTapped,
              borderRadius: BorderRadius.circular(kBorderRadMain),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPaddingMain / 2),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: kMinInteractiveDimension),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: titleHeroTag == null
                          ? titleEl
                          : Hero(
                            tag: titleHeroTag!,
                            child: titleEl,
                          ),
                      ),
                      if (onMoreTapped != null)
                        ...[
                          const SizedBox(width: kPaddingSecond),
                          IconButton(
                            onPressed: null,
                            icon: Icon(
                              Boxicons.bxs_chevron_right,
                              color: titleLarge?.color,
                            ),
                          ),
                        ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ShaderMask(
              shaderCallback: (Rect rect) => const LinearGradient(
                end: Alignment.center,
                tileMode: TileMode.mirror,
                colors: kShadowColors,
                stops: kShadowStops,
              ).createShader(rect),
              blendMode: BlendMode.dstOut,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isEpisode ? 2 : 1,
                  childAspectRatio: isEpisode ? 10 / 16 : 7 / 5,
                  mainAxisSpacing: kPaddingSecond,
                  crossAxisSpacing: kPaddingSecond,
                ),
                padding: const EdgeInsets.symmetric(horizontal: kPaddingMain),
                shrinkWrap: true,
                physics: kDefaultScrollPhysics,
                scrollDirection: Axis.horizontal,
                itemCount: itemCount,
                itemBuilder: itemBuilder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
