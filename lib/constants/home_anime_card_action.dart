
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/models/player_route_params.dart';
import 'package:nekodroid/provider/api.dart';
import 'package:nekosama/nekosama.dart';


enum HomeAnimeCardAction {
  openAnime,
  playFirstEp,
  copyTitle,
  copyLink,
  nothing;
  
  Future<void> doAction(NavigatorState navigator, WidgetRef ref, NSCarouselAnime anime) async {
    switch (this) {
      case openAnime:
        navigator.pushNamed("/anime", arguments: anime.url);
        return;
      case playFirstEp:
        final fullAnime = await ref.read(apiProv).getAnime(anime.url);
        if (fullAnime.episodes.isEmpty) {
          return;
        }
        navigator.pushNamed(
          "/player",
          arguments: PlayerRouteParams(
            episode: fullAnime.episodes.first,
            title: fullAnime.title,
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
