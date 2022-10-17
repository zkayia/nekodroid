
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/constants/home_anime_card_action.dart';
import 'package:nekodroid/constants/home_episode_card_action.dart';


@immutable
class HomeSettings {

  final int carouselColumnCount;
  final HomeEpisodeCardAction episodeCardPressAction;
  final HomeEpisodeCardAction episodeCardLongPressAction;
  final HomeAnimeCardAction animeCardPressAction;
  final HomeAnimeCardAction animeCardLongPressAction;
  
  const HomeSettings({
    this.carouselColumnCount=5,
    this.episodeCardPressAction=HomeEpisodeCardAction.playEpisodeNative,
    this.episodeCardLongPressAction=HomeEpisodeCardAction.openAnime,
    this.animeCardPressAction=HomeAnimeCardAction.openAnime,
    this.animeCardLongPressAction=HomeAnimeCardAction.copyLink,
  });

  HomeSettings copyWith({
    int? carouselColumnCount,
    HomeEpisodeCardAction? episodeCardPressAction,
    HomeEpisodeCardAction? episodeCardLongPressAction,
    HomeAnimeCardAction? animeCardPressAction,
    HomeAnimeCardAction? animeCardLongPressAction,
  }) => HomeSettings(
    carouselColumnCount: carouselColumnCount ?? this.carouselColumnCount,
    episodeCardPressAction: episodeCardPressAction ?? this.episodeCardPressAction,
    episodeCardLongPressAction: episodeCardLongPressAction ?? this.episodeCardLongPressAction,
    animeCardPressAction: animeCardPressAction ?? this.animeCardPressAction,
    animeCardLongPressAction: animeCardLongPressAction ?? this.animeCardLongPressAction,
  );

  Map<String, dynamic> toMap() => {
    "carouselColumnCount": carouselColumnCount,
    "episodeCardPressAction": episodeCardPressAction.index,
    "episodeCardLongPressAction": episodeCardLongPressAction.index,
    "animeCardPressAction": animeCardPressAction.index,
    "animeCardLongPressAction": animeCardLongPressAction.index,
  };

  factory HomeSettings.fromMap(Map<String, dynamic> map) => HomeSettings(
    carouselColumnCount: map["carouselColumnCount"]
      ?? kDefaultSettings.home.carouselColumnCount,
    episodeCardPressAction: HomeEpisodeCardAction.values.elementAt(
      map["episodeCardPressAction"] ?? kDefaultSettings.home.episodeCardPressAction.index,
    ),
    episodeCardLongPressAction: HomeEpisodeCardAction.values.elementAt(
      map["episodeCardLongPressAction"]
        ?? kDefaultSettings.home.episodeCardLongPressAction.index,
    ),
    animeCardPressAction: HomeAnimeCardAction.values.elementAt(
      map["animeCardPressAction"] ?? kDefaultSettings.home.animeCardPressAction.index,
    ),
    animeCardLongPressAction: HomeAnimeCardAction.values.elementAt(
      map["animeCardLongPressAction"]
        ?? kDefaultSettings.home.animeCardLongPressAction.index,
    ),
  );

  String toJson() => json.encode(toMap());

  factory HomeSettings.fromJson(String source) => HomeSettings.fromMap(json.decode(source));

  @override
  String toString() =>
    "HomeSettings(carouselColumnCount: $carouselColumnCount, episodeCardPressAction: $episodeCardPressAction, episodeCardLongPressAction: $episodeCardLongPressAction, animeCardPressAction: $animeCardPressAction, animeCardLongPressAction: $animeCardLongPressAction)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is HomeSettings
      && other.carouselColumnCount == carouselColumnCount
      && other.episodeCardPressAction == episodeCardPressAction
      && other.episodeCardLongPressAction == episodeCardLongPressAction
      && other.animeCardPressAction == animeCardPressAction
      && other.animeCardLongPressAction == animeCardLongPressAction;
  }

  @override
  int get hashCode => carouselColumnCount.hashCode
    ^ episodeCardPressAction.hashCode
    ^ episodeCardLongPressAction.hashCode
    ^ animeCardPressAction.hashCode
    ^ animeCardLongPressAction.hashCode;
}
