import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/extensions/datetime.dart';
import 'package:nekodroid/core/extensions/episode_history_data.dart';
import 'package:nekodroid/core/providers/db_sql.dart';
import 'package:nekodroid/core/widgets/labelled_icon.dart';
import 'package:nekodroid/features/player/data/player_route_params.dart';
import 'package:nekodroid/features/player/logic/show_controls.dart';
import 'package:nekodroid/features/player/logic/player_value.dart';
import 'package:nekodroid/features/player/logic/episode_data.dart';
import 'package:nekodroid/features/player/logic/web_msg_supported.dart';
import 'package:nekodroid/features/player/logic/webview.dart';
import 'package:nekodroid/features/player/logic/webview_channel_port.dart';
import 'package:nekodroid/features/player/widgets/player_controls.dart';
import 'package:nekodroid/features/player/widgets/player_gesture_detector.dart';
import 'package:nekodroid/features/player/widgets/player_webview.dart';
import 'package:nekodroid/features/settings/logic/settings.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final PlayerRouteParams params;

  const PlayerScreen(this.params, {super.key});

  @override
  PlayerScreenState createState() => PlayerScreenState();
}

class PlayerScreenState extends ConsumerState<PlayerScreen> with WidgetsBindingObserver {
  bool _playingBeforePause = false;
  bool _exited = false;
  var _openTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    WakelockPlus.enable();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _playingBeforePause = !(ref.read(playerValueProvider)?.paused ?? true);
      ref.read(webviewChannelPortProvider.notifier).pause();
    } else if (state == AppLifecycleState.resumed) {
      if (_playingBeforePause) {
        ref.read(webviewChannelPortProvider.notifier).play();
      }
    }
  }

  @override
  void dispose() {
    onExit();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void onExit() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
    SystemChrome.setPreferredOrientations([]);
    WakelockPlus.disable();
    saveToHistory();
  }

  void saveToHistory() async {
    final value = ref.read(playerValueProvider);
    final animeUrl = widget.params.anime?.url;
    if (value != null &&
        animeUrl != null &&
        value.currentTime.inSeconds > 10 &&
        _openTime.diffToNow().inSeconds > 10 &&
        !ref.read(settingsProvider).privateBrowsingEnabled) {
      final db = ref.read(dbSqlProvider);
      await db.transaction(() async {
        final now = DateTime.now();
        final recentEntry = await (db.select(db.episodeHistory)
              ..where(
                (tbl) =>
                    tbl.animeUrl.equalsValue(animeUrl) &
                    tbl.episodeNumber.equals(widget.params.episode.episodeNumber) &
                    tbl.time.isBiggerThanValue(now.subtract(const Duration(minutes: 10))),
              )
              ..orderBy([(tbl) => OrderingTerm.desc(tbl.time)])
              ..limit(1))
            .getSingleOrNull();
        if (recentEntry != null) {
          await (db.update(db.episodeHistory)..whereSamePrimaryKey(recentEntry)).write(
            EpisodeHistoryCompanion(
              time: Value(now),
              position: Value(value.currentTime),
            ),
          );
        } else {
          await db.into(db.episodeHistory).insertOnConflictUpdate(
                EpisodeHistoryCompanion.insert(
                  time: DateTime.now(),
                  animeUrl: animeUrl,
                  episodeNumber: widget.params.episode.episodeNumber,
                  position: value.currentTime,
                  duration: value.duration,
                ),
              );
        }
      });
    }
    // Resets time when going to previous/next ep
    _openTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) => _ProvidersKeepAlive(
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!_exited) {
              _exited = true;
              onExit();
              context.pop();
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: ref.watch(episodeDataProvider(widget.params)).when(
                  loading: () => const [CircularProgressIndicator()],
                  error: (error, stackTrace) => const [
                    LabelledIcon.vertical(
                      icon: Icon(Symbols.error_outline_rounded),
                      label: "Impossible de récupérer une video",
                    ),
                  ],
                  data: (data) {
                    if (data.videoUrls.isEmpty) {
                      return const [
                        LabelledIcon.vertical(
                          icon: Icon(Symbols.play_disabled_rounded),
                          label: "Aucune video trouvée",
                        ),
                      ];
                    }
                    return [
                      PlayerWebview(
                        url: data.videoUrls.first,
                        onMessageChannelSetup: (controller) {
                          if (data.episodeHistory != null && !data.episodeHistory!.completed) {
                            ref.read(webviewChannelPortProvider.notifier).goTo(data.episodeHistory!.position.inSeconds);
                          }
                        },
                      ),
                      if (ref.watch(webviewProvider.select((v) => v.isLoading)))
                        const CircularProgressIndicator()
                      else if (ref.watch(webMsgSupportedProvider)) ...[
                        if (ref.watch(playerValueProvider.select((v) => v?.buffering ?? true))) const CircularProgressIndicator(),
                        Positioned.fill(
                          child: PlayerGestureDetector(
                            controls: PlayerControls(
                              title: widget.params.title,
                              subtitle: "Episode ${widget.params.episode.episodeNumber}",
                              onExit: (context) {
                                if (!_exited) {
                                  _exited = true;
                                  onExit();
                                  context.pop();
                                }
                              },
                              onPrevious: widget.params.previous == null
                                  ? null
                                  : () {
                                      saveToHistory();
                                      context.pushReplacement("/player", extra: widget.params.previous);
                                    },
                              onNext: widget.params.next == null
                                  ? null
                                  : () {
                                      saveToHistory();
                                      context.pushReplacement("/player", extra: widget.params.next);
                                    },
                            ),
                          ),
                        ),
                      ] else
                        const LabelledIcon.vertical(
                          icon: Icon(Symbols.error_rounded),
                          label: "Messages web non supportés par la webview",
                        ),
                    ];
                  },
                ),
          ),
        ),
      );
}

class _ProvidersKeepAlive extends ConsumerWidget {
  final Widget child;

  const _ProvidersKeepAlive({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(showControlsProvider);
    ref.watch(playerValueProvider);
    ref.watch(webviewChannelPortProvider);
    ref.watch(webviewProvider);
    return child;
  }
}
