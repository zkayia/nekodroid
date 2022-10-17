
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/models/anime_settings.dart';
import 'package:nekodroid/models/general_settings.dart';
import 'package:nekodroid/models/home_settings.dart';
import 'package:nekodroid/models/library_settings.dart';
import 'package:nekodroid/models/player_settings.dart';
import 'package:nekodroid/models/search_settings.dart';
import 'package:nekodroid/models/session_settings.dart';


@immutable
class AppSettings {

  // Will reset on app restart
  final SessionSettings session;
  
  final GeneralSettings general;
  final HomeSettings home;
  final LibrarySettings library;
  final SearchSettings search;
  final AnimeSettings anime;
  final PlayerSettings player;
  
  const AppSettings({
    this.session=const SessionSettings(),
    this.general=const GeneralSettings(),
    this.home=const HomeSettings(),
    this.library=const LibrarySettings(),
    this.search=const SearchSettings(),
    this.anime=const AnimeSettings(),
    this.player=const PlayerSettings(),
  });

  AppSettings copyWith({
    SessionSettings? session,
    GeneralSettings? general,
    HomeSettings? home,
    LibrarySettings? library,
    SearchSettings? search,
    AnimeSettings? anime,
    PlayerSettings? player,
  }) => AppSettings(
    session: session ?? this.session,
    general: general ?? this.general,
    home: home ?? this.home,
    library: library ?? this.library,
    search: search ?? this.search,
    anime: anime ?? this.anime,
    player: player ?? this.player,
  );

  Map<String, dynamic> toMap() => {
    "general": general.toMap(),
    "home": home.toMap(),
    "library": library.toMap(),
    "search": search.toMap(),
    "anime": anime.toMap(),
    "player": player.toMap(),
  };

  factory AppSettings.fromMap(Map map) => AppSettings(
    general: map["general"] == null
      ? kDefaultSettings.general
      : GeneralSettings.fromMap(map["general"]),
    home: map["home"] == null
      ? kDefaultSettings.home
      : HomeSettings.fromMap(map["home"]),
    library: map["library"] == null
      ? kDefaultSettings.library
      : LibrarySettings.fromMap(map["library"]),
    search: map["search"] == null
      ? kDefaultSettings.search
      : SearchSettings.fromMap(map["search"]),
    anime: map["anime"] == null
      ? kDefaultSettings.anime
      : AnimeSettings.fromMap(map["anime"]),
    player: map["player"] == null
      ? kDefaultSettings.player
      : PlayerSettings.fromMap(map["player"]),
  );

  String toJson() => json.encode(toMap());

  factory AppSettings.fromJson(String source) => AppSettings.fromMap(json.decode(source));

  @override
  String toString() =>
    "AppSettings(general: $general, home: $home, library: $library, search: $search, anime: $anime, player: $player)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AppSettings
      && other.general == general
      && other.home == home
      && other.library == library
      && other.search == search
      && other.anime == anime
      && other.player == player;
  }

  @override
  int get hashCode => general.hashCode
    ^ home.hashCode
    ^ library.hashCode
    ^ search.hashCode
    ^ anime.hashCode
    ^ player.hashCode;
}
