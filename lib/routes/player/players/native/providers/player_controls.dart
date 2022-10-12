
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/extensions/datetime.dart';
import 'package:nekodroid/provider/settings.dart';


/* CONSTANTS */

enum DoubleTapAction {rewind, fastForward}


/* MODELS */

@immutable
class PlayerControlsData {

  final bool controlsDisplay;
  final DoubleTapAction? dtCurrent;
  final DoubleTapAction? dtDisplay;
  
  const PlayerControlsData({
    this.controlsDisplay=false,
    this.dtCurrent,
    this.dtDisplay,
  });

  PlayerControlsData copyWith({
    bool? controlsDisplay,
    DoubleTapAction? dtCurrent,
    DoubleTapAction? dtDisplay,
  }) => PlayerControlsData(
    controlsDisplay: controlsDisplay ?? this.controlsDisplay,
    dtCurrent: dtCurrent ?? this.dtCurrent,
    dtDisplay: dtDisplay ?? this.dtDisplay,
  );
}


/* PROVIDERS */

final playerControlsProvider = StateNotifierProvider.autoDispose<
  _PlayerControlsProviderNotifier,
  PlayerControlsData
>(
  _PlayerControlsProviderNotifier.new,
);


/* MISC */

class _PlayerControlsProviderNotifier extends StateNotifier<PlayerControlsData> {

  final Duration _playerControlsDisplayDuration;
  final Duration _playerQuickSkipDisplayDuration;
  bool isSeeking = false;
  bool isPlaying = false;
  bool isDone = false;
  bool inAction = false;
  DateTime? _lastActionTime;
  DateTime? _dtLastTime;

  _PlayerControlsProviderNotifier(Ref ref) :
    _playerControlsDisplayDuration = Duration(
      seconds: ref.read(settingsProvider).player.controlsDisplayDuration,
    ),
    _playerQuickSkipDisplayDuration = Duration(
      milliseconds: ref.read(settingsProvider).player.quickSkipDisplayDuration,
    ),
    super(const PlayerControlsData());

  set dtCurrent(DoubleTapAction? value) => state = PlayerControlsData(
    dtCurrent: value,
    dtDisplay: state.dtDisplay,
  );

  set dtDisplay(DoubleTapAction? value) => state = PlayerControlsData(
    dtCurrent: state.dtCurrent,
    dtDisplay: value,
  );

  void videoDone() {
    isDone = true;
    toggleControls(force: true);
  }

  void toggleControls({bool? force}) => state = state.copyWith(
    controlsDisplay: force ?? !state.controlsDisplay,
  );

  void didAction() {
    _lastActionTime = DateTime.now();
    _checkIn(_playerControlsDisplayDuration);
  }

  void dtUpdate(DoubleTapAction? action) {
    state = PlayerControlsData(
      dtCurrent: state.dtCurrent,
      dtDisplay: action,
    );
    _dtLastTime = DateTime.now();
    _checkIn(_playerQuickSkipDisplayDuration);
  }

  void _checkIn(Duration duration) => Future.delayed(
    duration + const Duration(microseconds: 1),
  ).then((_) => _check());

  void _check() {
    if (
      state.controlsDisplay
      && isPlaying && !isDone && !isSeeking && !inAction
      && (_lastActionTime?.diffToNow() ?? Duration.zero) >= _playerControlsDisplayDuration
    ) {
      toggleControls(force: false);
    }
    if (
      state.dtDisplay != null
      && (_dtLastTime?.diffToNow() ?? Duration.zero) >= _playerQuickSkipDisplayDuration
    ) {
      dtDisplay = null;
    }
  }
}


/* WIDGETS */
