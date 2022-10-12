
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:nekodroid/constants.dart';
import 'package:nekodroid/models/library_list.dart';

@immutable
class LibrarySettings {

  final bool enableTabbarScrolling;
  final int defaultTab;
  final bool enableHistory;
  final bool enableFavorites;
  final List<LibraryList>? lists;
  
  const LibrarySettings({
    this.enableTabbarScrolling=true,
    this.defaultTab=1,
    this.enableHistory=true,
    this.enableFavorites=true,
    this.lists,
  });

	LibrarySettings copyWith({
		bool? enableTabbarScrolling,
		int? defaultTab,
		bool? enableHistory,
		bool? enableFavorites,
		List<LibraryList>? lists,
	}) => LibrarySettings(
		enableTabbarScrolling: enableTabbarScrolling ?? this.enableTabbarScrolling,
		defaultTab: defaultTab ?? this.defaultTab,
		enableHistory: enableHistory ?? this.enableHistory,
		enableFavorites: enableFavorites ?? this.enableFavorites,
		lists: lists ?? this.lists,
	);

	Map<String, dynamic> toMap() => {
		"enableTabbarScrolling": enableTabbarScrolling,
		"defaultTab": defaultTab,
		"enableHistory": enableHistory,
		"enableFavorites": enableFavorites,
		"lists": lists?.map((x) => x.toMap()).toList(),
	};

	factory LibrarySettings.fromMap(Map<String, dynamic> map) => LibrarySettings(
    enableTabbarScrolling: map["enableTabbarScrolling"]
      ?? kDefaultSettings.library.enableTabbarScrolling,
    defaultTab: map["defaultTab"] ?? kDefaultSettings.library.defaultTab,
		enableHistory: map["enableHistory"] ?? kDefaultSettings.library.enableHistory,
		enableFavorites: map["enableFavorites"] ?? kDefaultSettings.library.enableFavorites,
    lists: map["lists"] == null
      ? kDefaultSettings.library.lists
      : List<LibraryList>.from(map["lists"]!.map(LibraryList.fromMap)),
	);

	String toJson() => json.encode(toMap());

	factory LibrarySettings.fromJson(String source) => LibrarySettings.fromMap(json.decode(source));

	@override
	String toString() =>
		"LibrarySettings(enableTabbarScrolling: $enableTabbarScrolling, defaultTab: $defaultTab, enableHistory: $enableHistory, enableFavorites: $enableFavorites, lists: $lists)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) {
      return true;
    }
		return other is LibrarySettings
			&& other.enableTabbarScrolling == enableTabbarScrolling
			&& other.defaultTab == defaultTab
			&& other.enableHistory == enableHistory
			&& other.enableFavorites == enableFavorites
			&& listEquals(other.lists, lists);
	}

	@override
	int get hashCode => enableTabbarScrolling.hashCode
		^ defaultTab.hashCode
		^ enableHistory.hashCode
		^ enableFavorites.hashCode
		^ lists.hashCode;
}
