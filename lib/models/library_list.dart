
import 'dart:convert';

import 'package:flutter/material.dart';


@immutable
class LibraryList {

  final int position;
  final String label;
  final IconData? icon;
  
  const LibraryList({
    required this.position,
    required this.label,
    this.icon,
  });

  LibraryList copyWith({
    int? position,
    String? label,
    IconData? icon,
  }) => LibraryList(
    position: position ?? this.position,
    label: label ?? this.label,
    icon: icon ?? this.icon,
  );

  Map<String, dynamic> toMap() => {
    "position": position,
    "label": label,
    "icon": icon?.codePoint,
  };

  factory LibraryList.fromMap(Map<String, dynamic> map) => LibraryList(
    position: map["position"] ?? 0,
    label: map["label"] ?? "",
    icon: map["icon"] != null ? IconData(map["icon"], fontFamily: "MaterialIcons") : null,
  );

  String toJson() => json.encode(toMap());

  factory LibraryList.fromJson(String source) => LibraryList.fromMap(json.decode(source));

  @override
  String toString() => "LibraryList(position: $position, label: $label, icon: $icon)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is LibraryList && other.position == position && other.label == label && other.icon == icon;
  }

  @override
  int get hashCode => position.hashCode ^ label.hashCode ^ icon.hashCode;
}
