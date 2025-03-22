import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/extensions/datetime.dart';
import 'package:nekodroid/features/player/data/double_tap_action.dart';
import 'package:nekodroid/features/player/data/player_settings.dart';
import 'package:nekodroid/features/player/logic/show_controls.dart';
import 'package:nekodroid/features/player/logic/webview_channel_port.dart';
import 'package:nekodroid/features/player/widgets/double_tap_action_overlay.dart';
import 'package:nekodroid/features/player/widgets/player_controls.dart';

class PlayerGestureDetector extends ConsumerStatefulWidget {
  final PlayerControls? controls;

  const PlayerGestureDetector({
    required this.controls,
    super.key,
  });

  @override
  ConsumerState<PlayerGestureDetector> createState() => _PlayerGestureDetectorState();
}

class _PlayerGestureDetectorState extends ConsumerState<PlayerGestureDetector> with SingleTickerProviderStateMixin {
  final _overlayDisplayDuration = Duration(milliseconds: const PlayerSettings().quickSkipDisplayDuration);
  late final Ticker _ticker;
  DoubleTapAction? _lastAction;
  OverlayEntry? _overlay;
  DateTime _lastOverlayActive = DateTime.now();

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      ref.read(showControlsProvider.notifier).runFrameCheck();
      if (_overlay != null && _lastOverlayActive.diffToNow() >= _overlayDisplayDuration) {
        updateOverlay();
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void updateOverlay([OverlayEntry? overlay]) {
    _overlay?.remove();
    _overlay = overlay;
    if (_overlay != null) {
      _lastOverlayActive = DateTime.now();
      Overlay.of(context).insert(_overlay!);
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onDoubleTap: () {
          if (_lastAction != null) {
            ref.read(webviewChannelPortProvider.notifier).moveBy(
                  switch (_lastAction!) {
                    DoubleTapAction.rewind => -const PlayerSettings().quickSkipBackwardTime,
                    DoubleTapAction.forward => const PlayerSettings().quickSkipBackwardTime,
                  },
                );
            if (_lastAction != null) {
              updateOverlay(OverlayEntry(builder: (context) => DoubleTapActionOverlay(_lastAction!)));
            }
          }
        },
        onDoubleTapDown: (tapDetails) {
          final screenSize = MediaQuery.of(context).size;
          final tapPos = tapDetails.globalPosition;
          if (ref.read(showControlsProvider) && (tapPos.dy < screenSize.height * 0.2 || screenSize.height * 0.8 < tapPos.dy)) {
            _lastAction = null;
            return;
          }
          final zoneWidth = screenSize.width * 0.3;
          if (tapPos.dx < zoneWidth) {
            _lastAction = DoubleTapAction.rewind;
          } else if (screenSize.width - zoneWidth < tapPos.dx) {
            _lastAction = DoubleTapAction.forward;
          } else {
            _lastAction = null;
          }
        },
        onTap: () {
          if (!ref.read(showControlsProvider) && const PlayerSettings().controlsPauseOnDisplay) {
            ref.read(webviewChannelPortProvider.notifier).pause();
          }
          ref.read(showControlsProvider.notifier)
            ..toggle()
            ..didAction();
        },
        child: IgnorePointer(
          ignoring: !ref.watch(showControlsProvider),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            curve: kDefaultAnimCurve,
            opacity: ref.watch(showControlsProvider) ? 1 : 0,
            child: widget.controls,
          ),
        ),
      );
}
