
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants/double_tap_action.dart';
import 'package:nekodroid/extensions/datetime.dart';
import 'package:nekodroid/models/player_controls_data.dart';
import 'package:nekodroid/provider/settings.dart';


final playerControlsProv = StateNotifierProvider.autoDispose<
  _PlayerControlsProvNotif,
  PlayerControlsData
>(
  _PlayerControlsProvNotif.new,
);

class _PlayerControlsProvNotif extends StateNotifier<PlayerControlsData> {

  final Duration _playerControlsDisplayDuration;
  final Duration _playerQuickSkipDisplayDuration;
  bool isSeeking = false;
  bool isPlaying = false;
  bool isDone = false;
  bool inAction = false;
  DateTime? _lastActionTime;
  DateTime? _dtLastTime;

  _PlayerControlsProvNotif(Ref ref) :
    _playerControlsDisplayDuration = Duration(
      seconds: ref.read(settingsProv).player.controlsDisplayDuration,
    ),
    _playerQuickSkipDisplayDuration = Duration(
      milliseconds: ref.read(settingsProv).player.quickSkipDisplayDuration,
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
