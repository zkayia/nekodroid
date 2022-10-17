
import 'package:android_intent_plus/android_intent.dart';
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/ns_anime_extended_base.dart';
import 'package:nekodroid/routes/anime/widgets/add_to_list_button.dart';
import 'package:nekodroid/widgets/anime_card.dart';
import 'package:nekodroid/widgets/anime_title.dart';
import 'package:nekodroid/widgets/generic_button.dart';
import 'package:nekodroid/widgets/generic_image.dart';
import 'package:nekodroid/widgets/single_line_text.dart';
import 'package:nekosama/nekosama.dart';
import 'package:share_plus/share_plus.dart';


/* CONSTANTS */




/* MODELS */




/* PROVIDERS */




/* MISC */




/* WIDGETS */

class AnimePageHeader extends StatelessWidget {

  final NSAnime anime; 

  const AnimePageHeader(this.anime, {super.key});

  @override
  Widget build(BuildContext context) {
    final thumbnail = Hero(
      tag: "anime_thumbnail",
      child: GenericImage(anime.thumbnail),
    );
    return LimitedBox(
      maxHeight: kAnimePageGroupMaxHeight,
      child: Row(
        children: [
          AnimeCard(
            image: thumbnail,
            onTap: () => Navigator.of(context).pushNamed(
              "/fullscreen_viewer",
              arguments: InteractiveViewer(
                child: thumbnail,
              ),
            ),
          ),
          const SizedBox(width: kPaddingSecond),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: FittedBox(
                    child: SingleLineText.secondary(
                      anime.dataText(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: AnimeTitle.bold(
                    anime.title,
                    textAlign: TextAlign.center,
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GenericButton.elevated(
                        onPressed: () => AndroidIntent(
                          action: "action_view",
                          data: anime.url.toString(),
                        ).launch(),
                        child: const Icon(Boxicons.bx_link_external),
                      ),
                      GenericButton.elevated(
                        onPressed: () => Share.share(
                          anime.url.toString(),
                          subject: anime.title,
                        ),
                        child: const Icon(Boxicons.bx_share_alt),
                      ),
                      AddToListButton(anime),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
