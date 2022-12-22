
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:nekodroid/constants.dart';


@immutable
class AnimeSettings {

  final bool blurThumbs;
  final int blurThumbsSigma;
  final int episodeCacheExtent;
  final bool keepEpisodesAlive;
  
  const AnimeSettings({
    this.blurThumbs=true,
    this.blurThumbsSigma=12,
    this.episodeCacheExtent=4,
    this.keepEpisodesAlive=false,
  });

  AnimeSettings copyWith({
    bool? blurThumbs,
    int? blurThumbsSigma,
    int? episodeCacheExtent,
    bool? keepEpisodesAlive,
  }) => AnimeSettings(
    blurThumbs: blurThumbs ?? this.blurThumbs,
    blurThumbsSigma: blurThumbsSigma ?? this.blurThumbsSigma,
    episodeCacheExtent: episodeCacheExtent ?? this.episodeCacheExtent,
    keepEpisodesAlive: keepEpisodesAlive ?? this.keepEpisodesAlive,
  );

  Map<String, dynamic> toMap() => {
    "blurThumbs": blurThumbs,
    "blurThumbsSigma": blurThumbsSigma,
    "episodeCacheExtent": episodeCacheExtent,
    "keepEpisodesAlive": keepEpisodesAlive,
  };

  factory AnimeSettings.fromMap(Map map) => AnimeSettings(
    blurThumbs: map["blurThumbs"] ?? kDefaultSettings.anime.blurThumbs,
    blurThumbsSigma: map["blurThumbsSigma"] ?? kDefaultSettings.anime.blurThumbsSigma,
    episodeCacheExtent: map["episodeCacheExtent"] ?? kDefaultSettings.anime.episodeCacheExtent,
    keepEpisodesAlive: map["keepEpisodesAlive"] ?? kDefaultSettings.anime.keepEpisodesAlive,
  );

  String toJson() => json.encode(toMap());

  factory AnimeSettings.fromJson(String source) => AnimeSettings.fromMap(json.decode(source));

  @override
  String toString() =>
    "AnimeSettings(blurThumbs: $blurThumbs, blurThumbsSigma: $blurThumbsSigma, episodeCacheExtent: $episodeCacheExtent, keepEpisodesAlive: $keepEpisodesAlive)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AnimeSettings
      && other.blurThumbs == blurThumbs
      && other.blurThumbsSigma == blurThumbsSigma
      && other.episodeCacheExtent == episodeCacheExtent
      && other.keepEpisodesAlive == keepEpisodesAlive;
  }

  @override
  int get hashCode => blurThumbs.hashCode
    ^ blurThumbsSigma.hashCode
    ^ episodeCacheExtent.hashCode
    ^ keepEpisodesAlive.hashCode;
}
