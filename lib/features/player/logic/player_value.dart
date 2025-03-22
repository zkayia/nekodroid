import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/core/extensions/size.dart';
import 'package:nekodroid/features/player/data/duration_range.dart';
import 'package:nekodroid/features/player/data/player_quality.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_value.g.dart';

@riverpod
class PlayerValue extends _$PlayerValue {
  @override
  PlayerValueState? build() => null;

  void set(PlayerValueState playerValue) => state = playerValue;
}

class PlayerValueState extends Equatable {
  final String? error;
  final bool paused;
  final bool ended;
  final bool muted;
  final bool buffering;
  final num playbackRate;
  final num volume;
  final Duration currentTime;
  final Duration duration;
  final Size videoSize;
  final List<PlayerQuality> qualities;
  final int? currentQuality;
  final List<DurationRange> buffered;
  final List<DurationRange> played;

  const PlayerValueState({
    required this.error,
    required this.paused,
    required this.ended,
    required this.muted,
    required this.buffering,
    required this.playbackRate,
    required this.volume,
    required this.currentTime,
    required this.duration,
    required this.videoSize,
    required this.qualities,
    required this.currentQuality,
    required this.buffered,
    required this.played,
  });

  @override
  List<Object?> get props => [
        error,
        paused,
        ended,
        muted,
        buffering,
        playbackRate,
        volume,
        currentTime,
        duration,
        videoSize,
        qualities,
        currentQuality,
        buffered,
        played,
      ];

  factory PlayerValueState.fromMap(Map<String, dynamic> map) => PlayerValueState(
        error: map["error"],
        paused: map["paused"] ?? false,
        ended: map["ended"] ?? false,
        muted: map["muted"] ?? false,
        buffering: map["buffering"] ?? false,
        playbackRate: map["playbackRate"] ?? 1,
        volume: map["volume"] ?? 1,
        currentTime: Duration(milliseconds: map["currentTime"] ?? 0),
        duration: Duration(milliseconds: map["duration"] ?? 0),
        videoSize: SizeX.fromMap(map["videoSize"]),
        qualities: [
          ...?(map["qualities"] as List?)?.cast<Map>().map((e) => e.cast<String, dynamic>()).map(PlayerQuality.fromMap),
        ],
        currentQuality: map["currentQuality"],
        buffered: [
          ...?(map["buffered"] as List?)?.cast<Map>().map((e) => e.cast<String, dynamic>()).map(DurationRange.fromMap),
        ],
        played: [
          ...?(map["played"] as List?)?.cast<Map>().map((e) => e.cast<String, dynamic>()).map(DurationRange.fromMap),
        ],
      );

  factory PlayerValueState.fromJson(String source) => PlayerValueState.fromMap(json.decode(source));
}
