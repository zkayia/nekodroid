
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants/player_type.dart';
import 'package:nekodroid/models/player_route_params.dart';
import 'package:nekodroid/provider/api.dart';
import 'package:nekosama/nekosama.dart';


enum HomeAnimeCardAction {
  openAnime,
  playFirstEpNative,
  playFirstEpWebview,
  copyTitle,
  copyLink,
  nothing;
  
  Future<void> doAction(NavigatorState navigator, WidgetRef ref, NSCarouselAnime anime) async {
    switch (this) {
      case openAnime:
        navigator.pushNamed("/anime", arguments: anime.url);
        return;
      case playFirstEpNative:
      case playFirstEpWebview:
        final fullAnime = await ref.read(apiProv).getAnime(anime.url);
        if (fullAnime.episodes.isEmpty) {
          return;
        }
        navigator.pushNamed(
          "/player",
          arguments: PlayerRouteParams(
            episode: fullAnime.episodes.first,
            playerType: this == playFirstEpNative
              ? PlayerType.native
              : PlayerType.webview,
          ),
        );
        return;
      case copyTitle:
        Clipboard.setData(
          ClipboardData(
            text: anime.title,
          ),
        );
        return;
      case copyLink:
        Clipboard.setData(
          ClipboardData(
            text: anime.url.toString(),
          ),
        );
        return;
      case nothing:
      default:
        return;
    }
  }
}
