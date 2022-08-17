
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/anime_title.dart';
import 'package:nekodroid/widgets/overflow_text.dart';


class AnimeListTile extends StatelessWidget {

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool titleWrap;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const AnimeListTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.titleWrap=true,
    this.onTap,
    this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) => LimitedBox(
    maxHeight: kAnimeListTileMaxHeight,
    child: Material(
      borderRadius: BorderRadius.circular(kBorderRadMain),
      color: Theme.of(context).listTileTheme.tileColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(kBorderRadMain),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null)
              ...[
                leading!,
                const SizedBox(width: kPaddingMain),
              ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: titleWrap
                      ? AnimeTitle.bold(title)
                      : FittedBox(child: AnimeTitle.bold(title)),
                  ),
                  if (subtitle != null)
                    ...[
                      const SizedBox(height: kPaddingSecond),
                      Flexible(
                        child: FittedBox(
                          child: OverflowText.secondary(subtitle ?? ""),
                        ),
                      ),
                    ],
                ],
              ),
            ),
            if (trailing != null)
              ...[
                const SizedBox(width: kPaddingMain),
                trailing!
              ],
          ],
        ),
      ),
    ),
  );
}
