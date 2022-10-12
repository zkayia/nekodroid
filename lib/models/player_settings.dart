
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';


@immutable
class PlayerSettings {

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
    this.confirmOnBackExit=true,
    this.backExitDuration=3,
    this.epContinueAtLastLocation=true,
    this.epAutoMarkCompleted=true,
    this.epAutoMarkCompletedThreshold=80,
    this.controlsDisplayDuration=3,
    this.controlsBackgroundTransparency=50,
    this.controlsPauseOnDisplay=true,
    this.introSkipTime=90,
    this.quickSkipForwardTime=10,
    this.quickSkipBackwardTime=10,
    this.quickSkipDisplayDuration=200,
  });

	PlayerSettings copyWith({
		bool? confirmOnBackExit,
		int? backExitDuration,
		bool? epContinueAtLastLocation,
		bool? epAutoMarkCompleted,
		int? epAutoMarkCompletedThreshold,
		int? controlsDisplayDuration,
		int? controlsBackgroundTransparency,
		bool? controlsPauseOnDisplay,
		int? introSkipTime,
		int? quickSkipForwardTime,
		int? quickSkipBackwardTime,
		int? quickSkipDisplayDuration,
	}) => PlayerSettings(
		confirmOnBackExit: confirmOnBackExit ?? this.confirmOnBackExit,
		backExitDuration: backExitDuration ?? this.backExitDuration,
		epContinueAtLastLocation: epContinueAtLastLocation ?? this.epContinueAtLastLocation,
		epAutoMarkCompleted: epAutoMarkCompleted ?? this.epAutoMarkCompleted,
		epAutoMarkCompletedThreshold: epAutoMarkCompletedThreshold ?? this.epAutoMarkCompletedThreshold,
		controlsDisplayDuration: controlsDisplayDuration ?? this.controlsDisplayDuration,
		controlsBackgroundTransparency: controlsBackgroundTransparency ?? this.controlsBackgroundTransparency,
		controlsPauseOnDisplay: controlsPauseOnDisplay ?? this.controlsPauseOnDisplay,
		introSkipTime: introSkipTime ?? this.introSkipTime,
		quickSkipForwardTime: quickSkipForwardTime ?? this.quickSkipForwardTime,
		quickSkipBackwardTime: quickSkipBackwardTime ?? this.quickSkipBackwardTime,
		quickSkipDisplayDuration: quickSkipDisplayDuration ?? this.quickSkipDisplayDuration,
	);

	Map<String, dynamic> toMap() => {
		"confirmOnBackExit": confirmOnBackExit,
		"backExitDelay": backExitDuration,
		"epContinueAtLastLocation": epContinueAtLastLocation,
		"epAutoMarkCompleted": epAutoMarkCompleted,
		"epAutoMarkCompletedThreshold": epAutoMarkCompletedThreshold,
		"controlsDisplayDuration": controlsDisplayDuration,
		"controlsBackgroundTransparency": controlsBackgroundTransparency,
		"controlsPauseOnDisplay": controlsPauseOnDisplay,
		"introSkipTime": introSkipTime,
		"quickSkipForwardTime": quickSkipForwardTime,
		"quickSkipBackwardTime": quickSkipBackwardTime,
		"quickSkipDisplayDuration": quickSkipDisplayDuration,
	};

	factory PlayerSettings.fromMap(Map<String, dynamic> map) => PlayerSettings(
		confirmOnBackExit: map["confirmOnBackExit"]
      ?? kDefaultSettings.player.confirmOnBackExit,
		backExitDuration: map["backExitDelay"]
      ?? kDefaultSettings.player.backExitDuration,
		epContinueAtLastLocation: map["epContinueAtLastLocation"]
      ?? kDefaultSettings.player.epContinueAtLastLocation,
		epAutoMarkCompleted: map["epAutoMarkCompleted"]
      ?? kDefaultSettings.player.epAutoMarkCompleted,
		epAutoMarkCompletedThreshold: map["epAutoMarkCompletedThreshold"]
      ?? kDefaultSettings.player.epAutoMarkCompletedThreshold,
		controlsDisplayDuration: map["controlsDisplayDuration"]
      ?? kDefaultSettings.player.controlsDisplayDuration,
		controlsBackgroundTransparency: map["controlsBackgroundTransparency"]
      ?? kDefaultSettings.player.controlsBackgroundTransparency,
		controlsPauseOnDisplay: map["controlsPauseOnDisplay"]
      ?? kDefaultSettings.player.controlsPauseOnDisplay,
		introSkipTime: map["introSkipTime"]
      ?? kDefaultSettings.player.introSkipTime,
		quickSkipForwardTime: map["quickSkipForwardTime"]
      ?? kDefaultSettings.player.quickSkipForwardTime,
		quickSkipBackwardTime: map["quickSkipBackwardTime"]
      ?? kDefaultSettings.player.quickSkipBackwardTime,
		quickSkipDisplayDuration: map["quickSkipDisplayDuration"]
      ?? kDefaultSettings.player.quickSkipDisplayDuration,
	);

	String toJson() => json.encode(toMap());

	factory PlayerSettings.fromJson(String source) => PlayerSettings.fromMap(json.decode(source));

	@override
	String toString() =>
		"PlayerSettings(confirmOnBackExit: $confirmOnBackExit, backExitDelay: $backExitDuration, epContinueAtLastLocation: $epContinueAtLastLocation, epAutoMarkCompleted: $epAutoMarkCompleted, epAutoMarkCompletedThreshold: $epAutoMarkCompletedThreshold, controlsDisplayDuration: $controlsDisplayDuration, controlsBackgroundTransparency: $controlsBackgroundTransparency, controlsPauseOnDisplay: $controlsPauseOnDisplay, introSkipTime: $introSkipTime, quickSkipForwardTime: $quickSkipForwardTime, quickSkipBackwardTime: $quickSkipBackwardTime, quickSkipDisplayDuration: $quickSkipDisplayDuration)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) {
      return true;
    }
		return other is PlayerSettings
			&& other.confirmOnBackExit == confirmOnBackExit
			&& other.backExitDuration == backExitDuration
			&& other.epContinueAtLastLocation == epContinueAtLastLocation
			&& other.epAutoMarkCompleted == epAutoMarkCompleted
			&& other.epAutoMarkCompletedThreshold == epAutoMarkCompletedThreshold
			&& other.controlsDisplayDuration == controlsDisplayDuration
			&& other.controlsBackgroundTransparency == controlsBackgroundTransparency
			&& other.controlsPauseOnDisplay == controlsPauseOnDisplay
			&& other.introSkipTime == introSkipTime
			&& other.quickSkipForwardTime == quickSkipForwardTime
			&& other.quickSkipBackwardTime == quickSkipBackwardTime
			&& other.quickSkipDisplayDuration == quickSkipDisplayDuration;
	}

	@override
	int get hashCode => confirmOnBackExit.hashCode
		^ backExitDuration.hashCode
		^ epContinueAtLastLocation.hashCode
		^ epAutoMarkCompleted.hashCode
		^ epAutoMarkCompletedThreshold.hashCode
		^ controlsDisplayDuration.hashCode
		^ controlsBackgroundTransparency.hashCode
		^ controlsPauseOnDisplay.hashCode
		^ introSkipTime.hashCode
		^ quickSkipForwardTime.hashCode
		^ quickSkipBackwardTime.hashCode
		^ quickSkipDisplayDuration.hashCode;
}
