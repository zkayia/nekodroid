
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants/player_type.dart';
import 'package:nekodroid/models/player_route_params.dart';
import 'package:nekodroid/provider/api.dart';
import 'package:nekosama/nekosama.dart';


enum HomeEpisodeCardAction {
  playEpisodeNative,
  playEpisodeWebview,
  openAnime,
  copyAnimeTitle,
  copyAnimeTitleWithEp,
  copyEpisodeLink,
  copyVideoLink,
  copyAnimeLink,
  nothing;

  Future<void> doAction(NavigatorState navigator, WidgetRef ref, NSNewEpisode episode) async {
    switch (this) {
      case playEpisodeNative:
      case playEpisodeWebview:
        navigator.pushNamed(
          "/player",
          arguments: PlayerRouteParams(
            episode: episode,
            playerType: this == playEpisodeNative
              ? PlayerType.native
              : PlayerType.webview,
          ),
        );
        return;
      case openAnime:
        navigator.pushNamed(
          "/anime",
          arguments: episode.animeUrl,
        );
        return;
      case copyAnimeTitle:
        Clipboard.setData(
          ClipboardData(
            text: episode.episodeTitle,
          ),
        );
        return;
      case copyAnimeTitleWithEp:
        Clipboard.setData(
          ClipboardData(
            text: "${episode.episodeTitle} #${episode.episodeNumber}",
          ),
        );
        return;
      case copyEpisodeLink:
        Clipboard.setData(
          ClipboardData(
            text: episode.url.toString(),
          ),
        );
        return;
      case copyVideoLink:
        Clipboard.setData(
          ClipboardData(
            text: (
              await ref.read(apiProv).getVideoUrl(episode)
            ).toString(),
          ),
        );
        return;
      case copyAnimeLink:
        Clipboard.setData(
          ClipboardData(
            text: episode.animeUrl.toString(),
          ),
        );
        return;
      case nothing:
      default:
        return;
    }
  }
}
