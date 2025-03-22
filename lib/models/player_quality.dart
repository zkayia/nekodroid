
import 'dart:convert';

import 'package:flutter/material.dart';


@immutable
class PlayerQuality {

  final int index;
  final int bitrate;
  final num height;
  final num width;
  final String label;
  
  const PlayerQuality({
    required this.index,
    required this.bitrate,
    required this.height,
    required this.width,
    required this.label,
  });

  PlayerQuality copyWith({
    int? index,
    int? bitrate,
    num? height,
    num? width,
    String? label,
  }) => PlayerQuality(
    index: index ?? this.index,
    bitrate: bitrate ?? this.bitrate,
    height: height ?? this.height,
    width: width ?? this.width,
    label: label ?? this.label,
  );

  Map<String, dynamic> toMap() => {
    "index": index,
    "bitrate": bitrate,
    "height": height,
    "width": width,
    "label": label,
  };

  factory PlayerQuality.fromMap(Map<String, dynamic> map) => PlayerQuality(
    index: map["index"] ?? 0,
    bitrate: map["bitrate"] ?? 0,
    height: map["height"] ?? 0,
    width: map["width"] ?? 0,
    label: map["label"] ?? "",
  );

  String toJson() => json.encode(toMap());

  factory PlayerQuality.fromJson(String source) => PlayerQuality.fromMap(json.decode(source));

  @override
  String toString() =>
    "PlayerQuality(index: $index, bitrate: $bitrate, height: $height, width: $width, label: $label)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is PlayerQuality
      && other.index == index
      && other.bitrate == bitrate
      && other.height == height
      && other.width == width
      && other.label == label;
  }

  @override
  int get hashCode => index.hashCode
    ^ bitrate.hashCode
    ^ height.hashCode
    ^ width.hashCode
    ^ label.hashCode;
}
