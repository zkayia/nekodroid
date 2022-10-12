
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/api.dart';
import 'package:nekodroid/provider/history.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/player/players/native/native.dart';
import 'package:nekodroid/routes/player/players/webview.dart';
import 'package:nekodroid/widgets/generic_route.dart';
import 'package:nekodroid/widgets/generic_toast_text.dart';
import 'package:nekodroid/widgets/large_icon.dart';
import 'package:nekosama/nekosama.dart';


/* CONSTANTS */

enum PlayerType {webview, native}

// TODO: preferred quality setting
enum Qualities {

  // Best available
  best("-1"),
  // Full HD 1080p
  fhd("1080"),
  // HD 720p
  hd("720"),
  // Standard Definition 576p or 480p
  sd("576"),
  // Low Definition 360p
  ld("360"),
  // Very Low Definition 240p
  vld("240");

  final String value;

  const Qualities(this.value);
}


/* MODELS */

@immutable
class PlayerRouteParameters {

  final PlayerType playerType;
  final NSEpisode episode;
  final NSAnime? anime;
  final int? currentIndex;

  const PlayerRouteParameters({
    required this.playerType,
    required this.episode,
    this.anime,
    this.currentIndex,
  }): assert(
    (anime == null && currentIndex == null)
    || (anime != null && currentIndex != null),
  );

  PlayerRouteParameters copyWith({
    PlayerType? playerType,
    NSEpisode? episode,
    NSAnime? anime,
    int? currentIndex,
  }) => PlayerRouteParameters(
    playerType: playerType ?? this.playerType,
    episode: episode ?? this.episode,
    anime: anime ?? this.anime,
    currentIndex: currentIndex ?? this.currentIndex,
  );
}


/* PROVIDERS */

final _playerPopTimeProvider = StateProvider.autoDispose<int>(
  (ref) => 0,
);

final _playerParamsProvider = StateProvider.autoDispose.family<
  PlayerRouteParameters,
  PlayerRouteParameters
>(
  (ref, params) => params,
);

final _videoProvider = FutureProvider.autoDispose.family<Uri?, PlayerRouteParameters>(
  (ref, params) => ref.watch(apiProvider).getVideoUrl(
    ref.watch(_playerParamsProvider(params).select((e) => e.episode)),
  ),
);


/* MISC */




/* WIDGETS */

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

  void _offsetCurrentEpBy(int offset, PlayerRouteParameters parameters) =>
    ref.read(_playerParamsProvider(parameters).notifier).update(
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
    final parameters = ModalRoute.of(context)!.settings.arguments as PlayerRouteParameters;
    ref.watch(_playerPopTimeProvider);
    return GenericRoute(
      hideExitFab: true,
      // useSafeArea: parameters.playerType != PlayerType.native,
      onExitTap: (context) async {
        if (!ref.read(settingsProvider).player.confirmOnBackExit) {
          return true;
        }
        final current = DateTime.now().millisecondsSinceEpoch;
        if (
          current - ref.read(_playerPopTimeProvider)
            > ref.read(settingsProvider).player.backExitDuration * 1000
        ) {
          ref.read(_playerPopTimeProvider.notifier).update((state) => current);
          fToast.showToast(
            child: GenericToastText(context.tr.playerConfirmExit),
            toastDuration: Duration(
              seconds: ref.read(settingsProvider).player.backExitDuration,
            ),
            gravity: ToastGravity.BOTTOM,
          );
          return false;
        }
        return true;
      },
      body: Center(
        child: ref.watch(_videoProvider(parameters)).when(
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
                  playerRouteParameters: ref.watch(_playerParamsProvider(parameters)),
                  onPrevious: 
                    parameters.anime == null
                    || (
                      ref.watch(
                        _playerParamsProvider(parameters).select((v) => v.currentIndex),
                      ) ?? 0
                    ) == 0
                      ? null
                      : () => _offsetCurrentEpBy(-1, parameters),
                  onNext: 
                    parameters.anime != null
                    && (
                      ref.watch(
                        _playerParamsProvider(parameters).select((v) => v.currentIndex),
                      ) ?? false
                    ) != parameters.anime!.episodes.length - 1
                      ? () {
                        final currentEp = ref.read(_playerParamsProvider(parameters)).episode;
                        _offsetCurrentEpBy(1, parameters);
                        if (ref.read(settingsProvider).player.epAutoMarkCompleted) {
                          ref.read(historyProvider.notifier).addEntry(
                            parameters.anime!.toJson(),
                            currentEp,
                            DateTime.now().millisecondsSinceEpoch,
                          ).then(
                            (success) => fToast.showToast(
                              child: GenericToastText(
                                context.tr.playerEpStatus(
                                  success,
                                  currentEp.episodeNumber,
                                ),
                              ),
                              gravity: ToastGravity.BOTTOM,
                            ),
                          );
                        }
                      }
                      : null,
                );
            }
          },
        ),
      ),
    );
  }
}
