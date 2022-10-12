
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:nekodroid/constants.dart';
import 'package:nekodroid/constants/nav_labels_mode.dart';

@immutable
class GeneralSettings {

  final ThemeMode themeMode;
  final bool useAmoled;
  final String locale;
  final int defaultPage;
  final NavLabelsMode navLabelsMode;
  final bool enableNavbarSwipe;
  final bool reverseNavbarSwipe;
  
  const GeneralSettings({
    this.themeMode=ThemeMode.system,
    this.useAmoled=false,
    this.locale="system",
    this.defaultPage=0,
    this.navLabelsMode=NavLabelsMode.all,
    this.enableNavbarSwipe=true,
    this.reverseNavbarSwipe=false,
  });


	GeneralSettings copyWith({
		ThemeMode? themeMode,
		bool? useAmoled,
		String? locale,
		int? defaultPage,
		NavLabelsMode? navLabelsMode,
		bool? enableNavbarSwipe,
		bool? reverseNavbarSwipe,
	}) => GeneralSettings(
		themeMode: themeMode ?? this.themeMode,
		useAmoled: useAmoled ?? this.useAmoled,
		locale: locale ?? this.locale,
		defaultPage: defaultPage ?? this.defaultPage,
		navLabelsMode: navLabelsMode ?? this.navLabelsMode,
		enableNavbarSwipe: enableNavbarSwipe ?? this.enableNavbarSwipe,
		reverseNavbarSwipe: reverseNavbarSwipe ?? this.reverseNavbarSwipe,
	);

	Map<String, dynamic> toMap() => {
		"themeMode": themeMode.index,
		"useAmoled": useAmoled,
		"locale": locale,
		"defaultPage": defaultPage,
		"navLabelsMode": navLabelsMode.index,
		"enableNavbarSwipe": enableNavbarSwipe,
		"reverseNavbarSwipe": reverseNavbarSwipe,
	};

	factory GeneralSettings.fromMap(Map<String, dynamic> map) => GeneralSettings(
		themeMode: ThemeMode.values.elementAt(
      map["themeMode"] ?? kDefaultSettings.general.themeMode.index,
    ),
		useAmoled: map["useAmoled"] ?? kDefaultSettings.general.useAmoled,
		locale: map["locale"] ?? kDefaultSettings.general.locale,
		defaultPage: map["defaultPage"] ?? kDefaultSettings.general.defaultPage,
		navLabelsMode: NavLabelsMode.values.elementAt(
      map["navLabelsMode"] ?? kDefaultSettings.general.navLabelsMode.index,
    ),
		enableNavbarSwipe: map["enableNavbarSwipe"]
      ?? kDefaultSettings.general.enableNavbarSwipe,
		reverseNavbarSwipe: map["reverseNavbarSwipe"]
      ?? kDefaultSettings.general.reverseNavbarSwipe,
	);

	String toJson() => json.encode(toMap());

	factory GeneralSettings.fromJson(String source) => GeneralSettings.fromMap(json.decode(source));

	@override
	String toString() =>
		"GeneralSettings(themeMode: $themeMode, useAmoled: $useAmoled, locale: $locale, defaultPage: $defaultPage, navLabelsMode: $navLabelsMode, enableNavbarSwipe: $enableNavbarSwipe, reverseNavbarSwipe: $reverseNavbarSwipe)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) {
      return true;
    }
		return other is GeneralSettings
			&& other.themeMode == themeMode
			&& other.useAmoled == useAmoled
			&& other.locale == locale
			&& other.defaultPage == defaultPage
			&& other.navLabelsMode == navLabelsMode
			&& other.enableNavbarSwipe == enableNavbarSwipe
			&& other.reverseNavbarSwipe == reverseNavbarSwipe;
	}

	@override
	int get hashCode => themeMode.hashCode
		^ useAmoled.hashCode
		^ locale.hashCode
		^ defaultPage.hashCode
		^ navLabelsMode.hashCode
		^ enableNavbarSwipe.hashCode
		^ reverseNavbarSwipe.hashCode;
}
