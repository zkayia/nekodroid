
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/anime_title.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class AnimeCard extends StatelessWidget {

  final Widget image;
  final String? badge;
  final bool isEpisode;
  final bool hidePlayButton;
  final String? label;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const AnimeCard({
    required this.image,
    this.badge,
    this.isEpisode=false,
    this.hidePlayButton=false,
    this.label,
    this.onTap,
    this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: isEpisode ? 16 / 9 : 5 / 7,
    child: Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRadMain),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                image,
                if (isEpisode && !hidePlayButton)
                  const ColoredBox(
                    color: kShadowThumbWithIcon,
                    child: Center(
                      child: Icon(
                        Boxicons.bx_play,
                        color: kOnImageColor,
                      ),
                    ),
                  ),
                if (badge != null)
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(kBorderRadMain),
                      ),
                      child: Material(
                        color: kAnimeCardBadgeShadow,
                        child: Padding(
                          padding: kAnimeCardBadgeTextPadding,
                          child: FittedBox(
                            child: SingleLineText(
                              badge ?? "",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: kAnimeCardBadgeColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(kBorderRadMain),
                      onTap: onTap,
                      onLongPress: onLongPress,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (label != null)
          AnimeTitle(label ?? "", isExtended: false),
      ],
    ),
  );
}
