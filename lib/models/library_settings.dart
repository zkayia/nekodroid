
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';


@immutable
class LibrarySettings {

  final bool enableTabbarScrolling;
  final int defaultTab;
  final bool enableHistory;
  final bool enableFavorites;
  
  const LibrarySettings({
    this.enableTabbarScrolling=false,
    this.defaultTab=-1,
    this.enableHistory=true,
    this.enableFavorites=true,
  });

  LibrarySettings copyWith({
    bool? enableTabbarScrolling,
    int? defaultTab,
    bool? enableHistory,
    bool? enableFavorites,
  }) => LibrarySettings(
    enableTabbarScrolling: enableTabbarScrolling ?? this.enableTabbarScrolling,
    defaultTab: defaultTab ?? this.defaultTab,
    enableHistory: enableHistory ?? this.enableHistory,
    enableFavorites: enableFavorites ?? this.enableFavorites,
  );

  Map<String, dynamic> toMap() => {
    "enableTabbarScrolling": enableTabbarScrolling,
    "defaultTab": defaultTab,
    "enableHistory": enableHistory,
    "enableFavorites": enableFavorites,
  };

  factory LibrarySettings.fromMap(Map<String, dynamic> map) => LibrarySettings(
    enableTabbarScrolling: map["enableTabbarScrolling"]
      ?? kDefaultSettings.library.enableTabbarScrolling,
    defaultTab: map["defaultTab"] ?? kDefaultSettings.library.defaultTab,
    enableHistory: map["enableHistory"] ?? kDefaultSettings.library.enableHistory,
    enableFavorites: map["enableFavorites"] ?? kDefaultSettings.library.enableFavorites,
  );

  String toJson() => json.encode(toMap());

  factory LibrarySettings.fromJson(String source) => LibrarySettings.fromMap(json.decode(source));

  @override
  String toString() =>
    "LibrarySettings(enableTabbarScrolling: $enableTabbarScrolling, defaultTab: $defaultTab, enableHistory: $enableHistory, enableFavorites: $enableFavorites)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is LibrarySettings
      && other.enableTabbarScrolling == enableTabbarScrolling
      && other.defaultTab == defaultTab
      && other.enableHistory == enableHistory
      && other.enableFavorites == enableFavorites;
  }

  @override
  int get hashCode => enableTabbarScrolling.hashCode
    ^ defaultTab.hashCode
    ^ enableHistory.hashCode
    ^ enableFavorites.hashCode;
}
