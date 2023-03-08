
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/build_context.dart';


class AnimeSynopsis extends StatelessWidget {

  final String? synopsis;

  const AnimeSynopsis(
    this.synopsis,
    {
      super.key,
    }
  );

  bool get hasSynopsis => synopsis?.isNotEmpty ?? false;

  @override
  Widget build(BuildContext context) {
    final synopsisW = Hero(
      tag: "anime_description",
      child: Text(
        hasSynopsis ? synopsis! : context.tr.animeNoSynopsis,
        textAlign: TextAlign.justify,
        overflow: TextOverflow.clip,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
    return LimitedBox(
      maxHeight: kAnimePageGroupMaxHeight,
      child: InkWell(
        onTap: hasSynopsis
          ? () => Navigator.of(context).pushNamed(
            "/fullscreen_viewer",
            arguments: synopsisW,
          )
          : null,
        borderRadius: BorderRadius.circular(kBorderRadMain),
        child: Padding(
          padding: const EdgeInsets.all(kPaddingSecond / 2),
          child: synopsisW,
        ),
      ),
    );
  }
}
