import 'package:nekodroid/core/extensions/datetime.dart';
import 'package:nekodroid/features/player/data/player_settings.dart';
import 'package:nekodroid/features/player/logic/player_value.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'show_controls.g.dart';

@riverpod
class ShowControls extends _$ShowControls {
  final _displayDuration = Duration(seconds: const PlayerSettings().controlsDisplayDuration);
  final _actions = <String, bool>{};
  DateTime _lastActive = DateTime.now();

  @override
  bool build() => false;

  void set(bool value) => state = value;
  void toggle() => state = !state;

  void didAction() => _lastActive = DateTime.now();

  void setActionState(String actionId, bool active) => _actions[actionId] = active;

  void runFrameCheck() {
    final value = ref.read(playerValueProvider);
    if (state &&
        !(value?.paused ?? false) &&
        !(value?.ended ?? false) &&
        _lastActive.diffToNow() >= _displayDuration &&
        _actions.values.every((active) => !active)) {
      set(false);
    }
  }
}

// class ControlsState extends Equatable {
//   final bool showControls;
//   // final bool showOverlay;
//   final DoubleTapAction? currentOverlay;

//   const ControlsState({
//     this.showControls = false,
//     // this.showOverlay = false,
//     this.currentOverlay,
//   });

//   @override
//   List<Object?> get props => [showControls, /* showOverlay, */ currentOverlay];

//   ControlsState copyWithNullable({
//     bool Function()? showControls,
//     // bool Function()? showOverlay,
//     DoubleTapAction? Function()? currentOverlay,
//   }) =>
//       ControlsState(
//         showControls: showControls?.call() ?? this.showControls,
//         // showOverlay: showOverlay?.call() ?? this.showOverlay,
//         currentOverlay: currentOverlay?.call() ?? this.currentOverlay,
//       );
// }
