
import 'dart:convert';

import 'package:flutter/material.dart';


@immutable
class DurationRange {
  
  final Duration start;
  final Duration end;
  
  const DurationRange(this.start, this.end);

  DurationRange copyWith({
    Duration? start,
    Duration? end,
  }) => DurationRange(
    start ?? this.start,
    end ?? this.end,
  );

  Map<String, dynamic> toMap() => {
    "start": start.inMilliseconds,
    "end": end.inMilliseconds,
  };

  factory DurationRange.fromMap(Map<String, dynamic> map) => DurationRange(
    Duration(milliseconds: map["start"] ?? 0),
    Duration(milliseconds: map["end"] ?? 0),
  );

  String toJson() => json.encode(toMap());

  factory DurationRange.fromJson(String source) => DurationRange.fromMap(json.decode(source));

  @override
  String toString() => "DurationRange(start: $start, end: $end)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is DurationRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
