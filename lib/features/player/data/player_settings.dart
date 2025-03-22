import 'package:equatable/equatable.dart';

class PlayerSettings extends Equatable {
  final bool confirmOnBackExit;

  /// in seconds
  final int backExitDuration;
  final bool epContinueAtLastLocation;
  final bool epAutoMarkCompleted;
  // in %, 0 for any
  final int epAutoMarkCompletedThreshold;

  /// in seconds
  final int controlsDisplayDuration;

  /// in %
  final int controlsBackgroundTransparency;
  final bool controlsPauseOnDisplay;

  /// in seconds
  final int introSkipTime;

  /// in seconds
  final int quickSkipForwardTime;

  /// in seconds
  final int quickSkipBackwardTime;

  /// in milliseconds
  final int quickSkipDisplayDuration;

  const PlayerSettings({
    this.confirmOnBackExit = true,
    this.backExitDuration = 3,
    this.epContinueAtLastLocation = true,
    this.epAutoMarkCompleted = true,
    this.epAutoMarkCompletedThreshold = 80,
    this.controlsPauseOnDisplay = false,
    this.controlsDisplayDuration = 3,
    this.controlsBackgroundTransparency = 50,
    this.introSkipTime = 90,
    this.quickSkipForwardTime = 10,
    this.quickSkipBackwardTime = 10,
    this.quickSkipDisplayDuration = 200,
  });

  @override
  List<Object?> get props => [
        confirmOnBackExit,
        backExitDuration,
        epContinueAtLastLocation,
        epAutoMarkCompleted,
        epAutoMarkCompletedThreshold,
        controlsPauseOnDisplay,
        controlsDisplayDuration,
        controlsBackgroundTransparency,
        introSkipTime,
        quickSkipForwardTime,
        quickSkipBackwardTime,
        quickSkipDisplayDuration,
      ];
}
