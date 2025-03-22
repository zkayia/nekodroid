
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/extensions/size.dart';
import 'package:nekodroid/models/duration_range.dart';
import 'package:nekodroid/models/player_quality.dart';


@immutable
class PlayerValue {

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
  
  const PlayerValue({
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

  Map<String, dynamic> toMap() => {
    "error": error,
    "paused": paused,
    "ended": ended,
    "muted": muted,
    "buffering": buffering,
    "playbackRate": playbackRate,
    "volume": volume,
    "currentTime": currentTime.inMilliseconds,
    "duration": duration.inMilliseconds,
    "videoSize": videoSize.toMap(),
    "qualities": qualities.map((x) => x.toMap()).toList(),
    "currentQuality": currentQuality,
    "buffered": buffered.map((x) => x.toMap()).toList(),
    "played": played.map((x) => x.toMap()).toList(),
  };

  factory PlayerValue.fromMap(Map<String, dynamic> map) => PlayerValue(
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
      ...?(map["qualities"] as List?)
        ?.cast<Map>()
        .map((e) => e.cast<String, dynamic>())
        .map(PlayerQuality.fromMap),
    ],
    currentQuality: map["currentQuality"],
    buffered: [
      ...?(map["buffered"] as List?)
        ?.cast<Map>()
        .map((e) => e.cast<String, dynamic>())
        .map(DurationRange.fromMap),
    ],
    played: [
      ...?(map["played"] as List?)
        ?.cast<Map>()
        .map((e) => e.cast<String, dynamic>())
        .map(DurationRange.fromMap),
    ],
  );

  String toJson() => json.encode(toMap());

  factory PlayerValue.fromJson(String source) => PlayerValue.fromMap(json.decode(source));


  @override
  String toString() =>
    "PlayerValue(error: $error, paused: $paused, ended: $ended, muted: $muted, buffering: $buffering, playbackRate: $playbackRate, volume: $volume, currentTime: $currentTime, duration: $duration, videoSize: $videoSize, qualities: $qualities, currentQuality: $currentQuality, buffered: $buffered, played: $played)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is PlayerValue
      && other.error == error
      && other.paused == paused
      && other.ended == ended
      && other.muted == muted
      && other.buffering == buffering
      && other.playbackRate == playbackRate
      && other.volume == volume
      && other.currentTime == currentTime
      && other.duration == duration
      && other.videoSize == videoSize
      && listEquals(other.qualities, qualities)
      && other.currentQuality == currentQuality
      && listEquals(other.buffered, buffered)
      && listEquals(other.played, played);
  }

  @override
  int get hashCode => error.hashCode
    ^ paused.hashCode
    ^ ended.hashCode
    ^ muted.hashCode
    ^ buffering.hashCode
    ^ playbackRate.hashCode
    ^ volume.hashCode
    ^ currentTime.hashCode
    ^ duration.hashCode
    ^ videoSize.hashCode
    ^ qualities.hashCode
    ^ currentQuality.hashCode
    ^ buffered.hashCode
    ^ played.hashCode;
}
