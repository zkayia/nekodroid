
import 'package:android_intent_plus/android_intent.dart';
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/helpers/anime_data_text.dart';
import 'package:nekodroid/provider/favorites.dart';
import 'package:nekodroid/widgets/anime_card.dart';
import 'package:nekodroid/widgets/anime_title.dart';
import 'package:nekodroid/widgets/generic_button.dart';
import 'package:nekodroid/widgets/generic_image.dart';
import 'package:nekodroid/widgets/single_line_text.dart';
import 'package:nekosama_dart/nekosama_dart.dart';
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
            onImageTap: () => Navigator.of(context).pushNamed(
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
                      animeDataText(context, anime),
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
                      _FavoriteButton(anime),
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

class _FavoriteButton extends ConsumerWidget {

  final NSAnime anime;

  const _FavoriteButton(this.anime);

  @override
  Widget build(BuildContext context, WidgetRef ref) => GenericButton.elevated(
    onPressed: () => ref.read(favoritesProvider.notifier).toggleFav(
      anime.url,
      DateTime.now(),
      anime,
    ),
    child: ref.watch(favoritesProvider).containsKey(anime.url)
      ? const Icon(
        Boxicons.bxs_heart,
        color: Colors.red,
      )
      : const Icon(Boxicons.bx_heart),
  );
}
