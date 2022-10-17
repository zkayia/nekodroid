
import 'package:flutter/material.dart';
import 'package:nekodroid/constants/double_tap_action.dart';


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
