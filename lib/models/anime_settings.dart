
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:nekodroid/constants.dart';


@immutable
class AnimeSettings {

  final bool blurThumbs;
  final int blurThumbsSigma;
  final int lazyLoadItemCount;
  
  const AnimeSettings({
    this.blurThumbs=true,
    this.blurThumbsSigma=12,
    this.lazyLoadItemCount=5,
  });

  AnimeSettings copyWith({
    bool? blurThumbs,
    int? blurThumbsSigma,
    int? lazyLoadItemCount,
    bool? autoAddToWatching,
  }) => AnimeSettings(
    blurThumbs: blurThumbs ?? this.blurThumbs,
    blurThumbsSigma: blurThumbsSigma ?? this.blurThumbsSigma,
    lazyLoadItemCount: lazyLoadItemCount ?? this.lazyLoadItemCount,
  );

  Map<String, dynamic> toMap() => {
    "blurThumbs": blurThumbs,
    "blurThumbsSigma": blurThumbsSigma,
    "lazyLoadItemCount": lazyLoadItemCount,
  };

  factory AnimeSettings.fromMap(Map map) => AnimeSettings(
    blurThumbs: map["blurThumbs"] ?? kDefaultSettings.anime.blurThumbs,
    blurThumbsSigma: map["blurThumbsSigma"] ?? kDefaultSettings.anime.blurThumbsSigma,
    lazyLoadItemCount: map["lazyLoadItemCount"] ?? kDefaultSettings.anime.lazyLoadItemCount,
  );

  String toJson() => json.encode(toMap());

  factory AnimeSettings.fromJson(String source) => AnimeSettings.fromMap(json.decode(source));

  @override
  String toString() =>
    "AnimeSettings(blurThumbs: $blurThumbs, blurThumbsSigma: $blurThumbsSigma, lazyLoadItemCount: $lazyLoadItemCount)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AnimeSettings
      && other.blurThumbs == blurThumbs
      && other.blurThumbsSigma == blurThumbsSigma
      && other.lazyLoadItemCount == lazyLoadItemCount;
  }

  @override
  int get hashCode => blurThumbs.hashCode
    ^ blurThumbsSigma.hashCode
    ^ lazyLoadItemCount.hashCode;
}
