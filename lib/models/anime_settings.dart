
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:nekodroid/constants.dart';

@immutable
class AnimeSettings {

  final bool blurThumbs;
  final int blurThumbsSigma;
  final int lazyLoadItemCount;
  final bool autoAddToWatching;
  
  const AnimeSettings({
    this.blurThumbs=true,
    this.blurThumbsSigma=12,
    this.lazyLoadItemCount=5,
    this.autoAddToWatching=true,
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
		autoAddToWatching: autoAddToWatching ?? this.autoAddToWatching,
	);

	Map<String, dynamic> toMap() => {
		"blurThumbs": blurThumbs,
		"blurThumbsSigma": blurThumbsSigma,
		"lazyLoadItemCount": lazyLoadItemCount,
		"autoAddToWatching": autoAddToWatching,
	};

	factory AnimeSettings.fromMap(Map<String, dynamic> map) => AnimeSettings(
		blurThumbs: map["blurThumbs"] ?? kDefaultSettings.anime.blurThumbs,
		blurThumbsSigma: map["blurThumbsSigma"] ?? kDefaultSettings.anime.blurThumbsSigma,
		lazyLoadItemCount: map["lazyLoadItemCount"] ?? kDefaultSettings.anime.lazyLoadItemCount,
		autoAddToWatching: map["autoAddToWatching"] ?? kDefaultSettings.anime.autoAddToWatching,
	);

	String toJson() => json.encode(toMap());

	factory AnimeSettings.fromJson(String source) => AnimeSettings.fromMap(json.decode(source));

	@override
	String toString() =>
		"AnimeSettings(blurThumbs: $blurThumbs, blurThumbsSigma: $blurThumbsSigma, lazyLoadItemCount: $lazyLoadItemCount, autoAddToWatching: $autoAddToWatching)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) {
      return true;
    }
		return other is AnimeSettings
			&& other.blurThumbs == blurThumbs
			&& other.blurThumbsSigma == blurThumbsSigma
			&& other.lazyLoadItemCount == lazyLoadItemCount
			&& other.autoAddToWatching == autoAddToWatching;
	}

	@override
	int get hashCode => blurThumbs.hashCode
		^ blurThumbsSigma.hashCode
		^ lazyLoadItemCount.hashCode
		^ autoAddToWatching.hashCode;
}
