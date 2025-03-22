
import 'dart:math';

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/models/player_route_params.dart';
import 'package:nekodroid/provider/api.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/player/providers/player_params.dart';
import 'package:nekodroid/routes/player/providers/player_pop_time.dart';
import 'package:nekodroid/routes/player/providers/webview_channel_port.dart';
import 'package:nekodroid/routes/player/providers/webview_controller.dart';
import 'package:nekodroid/routes/player/providers/player_errors.dart';
import 'package:nekodroid/routes/player/providers/webview_is_loading.dart';
import 'package:nekodroid/routes/player/providers/player_value.dart';
import 'package:nekodroid/routes/player/widgets/player_controls.dart';
import 'package:nekodroid/routes/player/widgets/player_controls_quick_skip_overlay.dart';
import 'package:nekodroid/routes/player/widgets/player_webview.dart';
import 'package:nekodroid/schemas/isar_anime_list_item.dart';
import 'package:nekodroid/schemas/isar_episode_status.dart';
import 'package:nekodroid/widgets/generic_route.dart';
import 'package:nekodroid/widgets/generic_toast_text.dart';
import 'package:nekodroid/widgets/labelled_icon.dart';
import 'package:nekodroid/widgets/large_icon.dart';
import 'package:wakelock/wakelock.dart';


class PlayerRoute extends ConsumerStatefulWidget {

  const PlayerRoute({super.key});

  @override
  PlayerRouteState createState() => PlayerRouteState();
}

class PlayerRouteState extends ConsumerState<PlayerRoute> {

  final webviewKey = GlobalKey();
  FToast fToast = FToast();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    fToast.init(context);
    Wakelock.enable();
    super.initState();
  }

  @override
  void dispose() {
    _onPlayerExit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initParams = ModalRoute.of(context)!.settings.arguments as PlayerRouteParams;
    return GenericRoute(
      hideExitFab: true,
      onExitTap: (context) async {
        if (!ref.read(settingsProv).player.confirmOnBackExit) {
          _onPlayerExit();
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
          initParams: initParams,
        );
        _onPlayerExit();
        return true;
      },
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            const SizedBox.expand(
              child: ColoredBox(
                color: Colors.black,
              ),
            ),
            PlayerWebview(
              webviewKey: webviewKey,
              onWebviewCreated: (_) => loadCurrentEp(initParams),
              onMessageChannelSetup: (_) {
                if (ref.read(settingsProv).player.epContinueAtLastLocation) {
                  ref.read(webviewChannelPortProv.notifier).goTo(
                    Isar.getInstance()?.isarEpisodeStatus.getByUrlSync(
                      ref.read(playerParamsProv(initParams)).episode.url.toString(),
                    )?.lastPositionDuration?.inSeconds ?? 0,
                  );
                }
              },
            ),
            if (ref.watch(playerErrorsProv).isNotEmpty)
              LabelledIcon.vertical(
                icon: const LargeIcon(Boxicons.bx_error_circle),
                label: ref.watch(playerErrorsProv).take(5).join("\n"),
              )
            else if (ref.watch(webviewIsLoadingProv) || ref.watch(playerValueProv) == null)
              const CircularProgressIndicator()
            else
              ...[
                if (ref.watch(playerValueProv.select((v) => v?.buffering ?? false)))
                  const CircularProgressIndicator(),
                PlayerControls(
                  title: ref.watch(playerParamsProv(initParams).select((v) => v.title)),
                  subtitle: context.tr.episodeLong(
                    ref.watch(playerParamsProv(initParams).select((v) => v.episode.episodeNumber)),
                  ),
                  onExit: (context) => _updateEp(
                    ref: ref,
                    initParams: initParams,
                  ).then(
                    (_) => Navigator.of(context).pop(),
                  ),
                  onPrevious: 
                    initParams.anime == null
                    || (
                      ref.watch(playerParamsProv(initParams).select((v) => v.currentIndex))
                        ?? 0
                    ) == 0
                      ? null
                      : () {
                        _offsetCurrentEpBy(-1, initParams);
                        loadCurrentEp(initParams);
                      },
                  onNext: 
                    initParams.anime != null
                    && (
                      ref.watch(playerParamsProv(initParams).select((v) => v.currentIndex))
                        ?? false
                    ) != initParams.anime!.episodes.length - 1
                      ? () async {
                        await _updateEp(
                          ref: ref,
                          initParams: initParams,
                        );
                        _offsetCurrentEpBy(1, initParams);
                        loadCurrentEp(initParams);
                      }
                      : null,
                ),
                const PlayerControlsQuickSkipOverlay(),
              ],
          ],
        ),
      ),
    );
  }

  void _onPlayerExit() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    fToast
      ..removeQueuedCustomToasts()
      ..removeCustomToast();
    Wakelock.disable();
    ref
      ..invalidate(playerPopTimeProv)
      ..invalidate(webviewControllerProv)
      ..invalidate(playerParamsProv)
      ..invalidate(webviewChannelPortProv);
  }

  void _offsetCurrentEpBy(int offset, PlayerRouteParams initParams) {
    ref.read(playerParamsProv(initParams).notifier).update(
      (state) {
        final newIndex = state.currentIndex! + offset;
        return state.copyWith(
          episode: state.anime!.episodes.elementAt(newIndex),
          currentIndex: newIndex,
        );
      },
    );
  }

  Future<void> loadCurrentEp(PlayerRouteParams initParams) async {
    final videoUrls = await ref.watch(apiProv).getVideoUrls(
      ref.read(playerParamsProv(initParams)).episode,
    );
    if (videoUrls.isEmpty) {
      ref.read(playerErrorsProv.notifier).update(
        (state) => [
          "No video found",
          ...state
        ],
      );
    } else {
      ref.read(webviewControllerProv)?.loadUrl(
        urlRequest: URLRequest(url: videoUrls.first),
      );
    }
  }

  Future<void> _updateEp({
    required WidgetRef ref,
    required PlayerRouteParams initParams,
  }) async {
    if (ref.read(settingsProv).session.privateBrowsingEnabled) {
      return;
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    final playerSettings = ref.read(settingsProv).player;
    final episode = ref.read(playerParamsProv(initParams)).episode;
    final duration = ref.read(playerValueProv)?.duration.inMilliseconds ?? 0;
    final position = max(
      (ref.read(playerValueProv)?.currentTime.inMilliseconds ?? 0) - 10 * 1000,
      0,
    );
    final isar = Isar.getInstance()!;
    await isar.writeTxn(() async {
      var isarEp = await isar.isarEpisodeStatus.getByUrl(episode.url.toString());
      if (isarEp == null) {
        if (position == 0) {
          return;
        }
        final animeUrl = initParams.anime?.url ?? episode.animeUrl;
        var isarAnime = await isar.isarAnimeListItems.getByUrl(animeUrl.toString());
        await isarAnime?.episodeStatuses.load();
        isarEp = IsarEpisodeStatus.fromNSEpisode(episode);
        isarAnime ??= IsarAnimeListItem.fromNSAnime(
          initParams.anime ?? (await ref.read(apiProv).getAnime(animeUrl)),
        );
        isarAnime.episodeStatuses.add(isarEp);
        await isar.isarEpisodeStatus.put(isarEp);
        await isar.isarAnimeListItems.put(isarAnime);
        await isarAnime.episodeStatuses.save();
      }
      if (position != 0 && playerSettings.epContinueAtLastLocation) {
        isarEp.lastPosition = position;
      }
      if (duration != 0) {
        isarEp.duration = duration;
      }
      if (
        playerSettings.epAutoMarkCompleted
        && (
          isarEp.watchedFraction == null
            ? false
            : isarEp.watchedFraction! * 100 >= playerSettings.epAutoMarkCompletedThreshold
        )
      ) {
        isarEp.watchedTimestamps = [...isarEp.watchedTimestamps, now];
      }
      isarEp.lastExitTimestamp = now;
      await isar.isarEpisodeStatus.put(isarEp);
    });
  }
}
