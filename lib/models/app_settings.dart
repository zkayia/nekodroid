
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/helpers/nav_labels_mode.dart';
import 'package:nekodroid/helpers/resolve_thememode.dart';


@immutable
class AppSettings {

	final ThemeMode themeMode;
	final int defaultPage;
	final int carouselItemCount;
	final bool secrecyEnabled;
	final bool blurThumbs;
	final bool blurThumbsShowSwitch;
	final double blurThumbsSigma;
	final NavLabelsMode navLabelsMode;
	final int lazyLoadItemCount;
	
	const AppSettings({
		required this.themeMode,
		required this.defaultPage,
		required this.carouselItemCount,
		required this.secrecyEnabled,
		required this.blurThumbs,
		required this.blurThumbsShowSwitch,
		required this.blurThumbsSigma,
		required this.navLabelsMode,
		required this.lazyLoadItemCount,
	});

	AppSettings copyWith({
		ThemeMode? themeMode,
		int? defaultPage,
		int? carouselItemCount,
		bool? secrecyEnabled,
		bool? blurThumbs,
		bool? blurThumbsShowSwitch,
		double? blurThumbsSigma,
		NavLabelsMode? navLabelsMode,
		int? lazyLoadItemCount,
	}) => AppSettings(
		themeMode: themeMode ?? this.themeMode,
		defaultPage: defaultPage ?? this.defaultPage,
		carouselItemCount: carouselItemCount ?? this.carouselItemCount,
		secrecyEnabled: secrecyEnabled ?? this.secrecyEnabled,
		blurThumbs: blurThumbs ?? this.blurThumbs,
		blurThumbsShowSwitch: blurThumbsShowSwitch ?? this.blurThumbsShowSwitch,
		blurThumbsSigma: blurThumbsSigma ?? this.blurThumbsSigma,
		navLabelsMode: navLabelsMode ?? this.navLabelsMode,
		lazyLoadItemCount: lazyLoadItemCount ?? this.lazyLoadItemCount,
	);

	Map<String, dynamic> toMap() => {
		"themeMode": themeMode.name,
		"defaultPage": defaultPage,
		"carouselItemCount": carouselItemCount,
		"secrecyEnabled": secrecyEnabled,
		"blurThumbs": blurThumbs,
		"blurThumbsShowSwitch": blurThumbsShowSwitch,
		"blurThumbsSigma": blurThumbsSigma,
		"navLabelsMode": navLabelsMode.name,
		"lazyLoadItemCount": lazyLoadItemCount,
	};

	factory AppSettings.fromMap(Map<String, dynamic> map) => AppSettings(
		themeMode: resolveThemeMode(map["themeMode"]) ?? kDefaultSettings.themeMode,
		defaultPage: map["defaultPage"] ?? kDefaultSettings.defaultPage,
		carouselItemCount: map["carouselItemCount"] ?? kDefaultSettings.carouselItemCount,
		secrecyEnabled: map["secrecyEnabled"] ?? kDefaultSettings.secrecyEnabled,
		blurThumbs: map["blurThumbs"] ?? kDefaultSettings.blurThumbs,
		blurThumbsShowSwitch: map["blurThumbsShowSwitch"] ?? kDefaultSettings.blurThumbsShowSwitch,
		blurThumbsSigma: map["blurThumbsSigma"] ?? kDefaultSettings.blurThumbsSigma,
		navLabelsMode: resolveNavLabelsMode(map["navLabelsMode"]) ?? kDefaultSettings.navLabelsMode,
		lazyLoadItemCount: map["lazyLoadItemCount"] ?? kDefaultSettings.lazyLoadItemCount,
	);

	String toJson() => json.encode(toMap());

	factory AppSettings.fromJson(String source) => AppSettings.fromMap(json.decode(source));

	@override
	String toString() =>
		"AppSettings(themeMode: $themeMode, defaultPage: $defaultPage, carouselItemCount: $carouselItemCount, privateBrowsingEnabled: $secrecyEnabled, blurThumbs: $blurThumbs, blurThumbsShowSwitch: $blurThumbsShowSwitch, blurThumbsSigma: $blurThumbsSigma, navLabelsMode: $navLabelsMode, lazyLoadItemCount: $lazyLoadItemCount)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) return true;
		return other is AppSettings
			&& other.themeMode == themeMode
			&& other.defaultPage == defaultPage
			&& other.carouselItemCount == carouselItemCount
			&& other.secrecyEnabled == secrecyEnabled
			&& other.blurThumbs == blurThumbs
			&& other.blurThumbsShowSwitch == blurThumbsShowSwitch
			&& other.blurThumbsSigma == blurThumbsSigma
			&& other.navLabelsMode == navLabelsMode
			&& other.lazyLoadItemCount == lazyLoadItemCount;
	}

	@override
	int get hashCode => themeMode.hashCode
		^ defaultPage.hashCode
		^ carouselItemCount.hashCode
		^ secrecyEnabled.hashCode
		^ blurThumbs.hashCode
		^ blurThumbsShowSwitch.hashCode
		^ blurThumbsSigma.hashCode
		^ navLabelsMode.hashCode
		^ lazyLoadItemCount.hashCode;
}
