
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/constants/player_type.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/models/player_route_params.dart';
import 'package:nekodroid/provider/api.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/player/native/native.dart';
import 'package:nekodroid/routes/player/providers/player_value.dart';
import 'package:nekodroid/routes/player/providers/player_params.dart';
import 'package:nekodroid/routes/player/providers/player_pop_time.dart';
import 'package:nekodroid/routes/player/providers/video.dart';
import 'package:nekodroid/routes/player/webview/webview.dart';
import 'package:nekodroid/schemas/isar_anime_list_item.dart';
import 'package:nekodroid/schemas/isar_episode_status.dart';
import 'package:nekodroid/widgets/generic_route.dart';
import 'package:nekodroid/widgets/generic_toast_text.dart';
import 'package:nekodroid/widgets/large_icon.dart';


class PlayerRoute extends ConsumerStatefulWidget {

  const PlayerRoute({super.key});

  @override
  PlayerRouteState createState() => PlayerRouteState();
}

class PlayerRouteState extends ConsumerState<PlayerRoute> {

  FToast fToast = FToast();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    fToast
      ..removeQueuedCustomToasts()
      ..removeCustomToast();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void _offsetCurrentEpBy(int offset, PlayerRouteParams parameters) =>
    ref.read(playerParamsProv(parameters).notifier).update(
      (state) {
        final newIndex = state.currentIndex! + offset;
        return state.copyWith(
          episode: state.anime!.episodes.elementAt(newIndex),
          currentIndex: newIndex,
        );
      },
    );

  @override
  Widget build(BuildContext context) {
    final parameters = ModalRoute.of(context)!.settings.arguments as PlayerRouteParams;
    // To keep the state when disabling visibility
    // when riverpod ^2.0.0 comes
    // remove thoses and autoDispose then ref.invalidate it in dispose
    ref
      ..watch(playerPopTimeProv)
      ..watch(playerValueProv);
    return GenericRoute(
      hideExitFab: true,
      onExitTap: (context) async {
        if (!ref.read(settingsProv).player.confirmOnBackExit) {
          return true;
        }
        final current = DateTime.now().millisecondsSinceEpoch;
        if (
          current - ref.read(playerPopTimeProv)
            > ref.read(settingsProv).player.backExitDuration * 1000
        ) {
          ref.read(playerPopTimeProv.notifier).update((state) => current);
          fToast.showToast(
            child: GenericToastText(context.tr.playerConfirmExit),
            toastDuration: Duration(
              seconds: ref.read(settingsProv).player.backExitDuration,
            ),
          );
          return false;
        }
        _updateEp(
          ref: ref,
          parameters: parameters,
        );
        return true;
      },
      body: Center(
        child: ref.watch(videoProv(parameters)).when(
          loading: () => const CircularProgressIndicator(),
          error: (err, stackTrace) => const LargeIcon(Boxicons.bxs_error_circle),
          data: (videoUrl) {
            if (videoUrl == null) {
              return const LargeIcon(Boxicons.bxs_error_circle);
            }
            switch (parameters.playerType) {
              case PlayerType.webview:
                return WebviewPlayer(videoUrl: videoUrl);
              case PlayerType.native:
                return NativePlayer(
                  videoUrl: videoUrl,
                  playerRouteParameters: ref.watch(playerParamsProv(parameters)),
                  onExit: (context) => _updateEp(
                    ref: ref,
                    parameters: parameters,
                  ).then(
                    (_) => Navigator.of(context).pop(),
                  ),
                  onPrevious: 
                    parameters.anime == null
                    || (
                      ref.watch(
                        playerParamsProv(parameters).select((v) => v.currentIndex),
                      ) ?? 0
                    ) == 0
                      ? null
                      : () => _offsetCurrentEpBy(-1, parameters),
                  onNext: 
                    parameters.anime != null
                    && (
                      ref.watch(
                        playerParamsProv(parameters).select((v) => v.currentIndex),
                      ) ?? false
                    ) != parameters.anime!.episodes.length - 1
                      ? () async {
                        await _updateEp(
                          ref: ref,
                          parameters: parameters,
                        );
                        _offsetCurrentEpBy(1, parameters);
                      }
                      : null,
                );
            }
          },
        ),
      ),
    );
  }

  Future<void> _updateEp({
    required WidgetRef ref,
    required PlayerRouteParams parameters,
  }) async {
    if (ref.read(settingsProv).session.privateBrowsingEnabled) {
      return;
    }
    final episode = ref.read(playerParamsProv(parameters)).episode;
    final duration = parameters.playerType == PlayerType.native
      ? ref.read(playerValueProv).duration
      : null;
    final position = parameters.playerType == PlayerType.native
      ? ref.read(playerValueProv).position
      : null;
    final isar = Isar.getInstance()!;
    await isar.writeTxn(() async {
      var isarEp = await isar.isarEpisodeStatus.getByUrl(episode.url.toString());
      if (isarEp == null) {
        final anime = ref.read(playerParamsProv(parameters)).anime;
        final animeUrl = anime?.url ?? episode.animeUrl;
        var isarAnime = await isar.isarAnimeListItems.getByUrl(animeUrl.toString());
        if (isarAnime != null) {
          await isarAnime.episodeStatuses.load();
        }
        isarEp = IsarEpisodeStatus.fromNSEpisode(episode);
        isarAnime ??= IsarAnimeListItem.fromNSAnime(
          anime ?? (await ref.read(apiProv).getAnime(animeUrl)),
        );
        isarAnime.episodeStatuses.add(isarEp);
        await isar.isarEpisodeStatus.put(isarEp);
        await isar.isarAnimeListItems.put(isarAnime);
        await isarAnime.episodeStatuses.save();
      }
      if (position != null && ref.read(settingsProv).player.epContinueAtLastLocation) {
        isarEp.lastExitTime = position.inMilliseconds;
      }
      if (
        ref.read(settingsProv).player.epAutoMarkCompleted
        && (100 * (position?.inMilliseconds ?? 1) / (duration?.inMilliseconds ?? 1))
          >= ref.read(settingsProv).player.epAutoMarkCompletedThreshold
      ) {
        isarEp.watchedTimestamps = [
          ...isarEp.watchedTimestamps,
          DateTime.now().millisecondsSinceEpoch,
        ];
      }
      await isar.isarEpisodeStatus.put(isarEp);
    });
  }
}
