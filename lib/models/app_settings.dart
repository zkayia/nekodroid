
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/helpers/nav_labels_mode.dart';
import 'package:nekodroid/helpers/resolve_thememode.dart';


@immutable
class AppSettings {

  final String locale;
  final ThemeMode themeMode;
  final bool useAmoled;
  final int defaultPage;
  final int carouselItemCount;
  final bool secrecyEnabled;
  final bool blurThumbs;
  final double blurThumbsSigma;
  final NavLabelsMode navLabelsMode;
  final int lazyLoadItemCount;
  
  const AppSettings({
    required this.locale,
    required this.themeMode,
    required this.useAmoled,
    required this.defaultPage,
    required this.carouselItemCount,
    required this.secrecyEnabled,
    required this.blurThumbs,
    required this.blurThumbsSigma,
    required this.navLabelsMode,
    required this.lazyLoadItemCount,
  });

  AppSettings copyWith({
    String? locale,
    ThemeMode? themeMode,
    bool? useAmoled,
    int? defaultPage,
    int? carouselItemCount,
    bool? secrecyEnabled,
    bool? blurThumbs,
    bool? blurThumbsShowSwitch,
    double? blurThumbsSigma,
    NavLabelsMode? navLabelsMode,
    int? lazyLoadItemCount,
  }) => AppSettings(
    locale: locale ?? this.locale,
    themeMode: themeMode ?? this.themeMode,
    useAmoled: useAmoled ?? this.useAmoled,
    defaultPage: defaultPage ?? this.defaultPage,
    carouselItemCount: carouselItemCount ?? this.carouselItemCount,
    secrecyEnabled: secrecyEnabled ?? this.secrecyEnabled,
    blurThumbs: blurThumbs ?? this.blurThumbs,
    blurThumbsSigma: blurThumbsSigma ?? this.blurThumbsSigma,
    navLabelsMode: navLabelsMode ?? this.navLabelsMode,
    lazyLoadItemCount: lazyLoadItemCount ?? this.lazyLoadItemCount,
  );

  Map<String, dynamic> toMap() => {
    "locale": locale,
    "themeMode": themeMode.name,
    "useAmoled": useAmoled,
    "defaultPage": defaultPage,
    "carouselItemCount": carouselItemCount,
    "secrecyEnabled": secrecyEnabled,
    "blurThumbs": blurThumbs,
    "blurThumbsSigma": blurThumbsSigma,
    "navLabelsMode": navLabelsMode.name,
    "lazyLoadItemCount": lazyLoadItemCount,
  };

  factory AppSettings.fromMap(Map<String, dynamic> map) => AppSettings(
    locale: map["locale"] ?? kDefaultSettings.locale,
    themeMode: resolveThemeMode(map["themeMode"]) ?? kDefaultSettings.themeMode,
    useAmoled: map["useAmoled"] ?? kDefaultSettings.useAmoled,
    defaultPage: map["defaultPage"] ?? kDefaultSettings.defaultPage,
    carouselItemCount: map["carouselItemCount"] ?? kDefaultSettings.carouselItemCount,
    secrecyEnabled: map["secrecyEnabled"] ?? kDefaultSettings.secrecyEnabled,
    blurThumbs: map["blurThumbs"] ?? kDefaultSettings.blurThumbs,
    blurThumbsSigma: map["blurThumbsSigma"] ?? kDefaultSettings.blurThumbsSigma,
    navLabelsMode: resolveNavLabelsMode(map["navLabelsMode"]) ?? kDefaultSettings.navLabelsMode,
    lazyLoadItemCount: map["lazyLoadItemCount"] ?? kDefaultSettings.lazyLoadItemCount,
  );
}
