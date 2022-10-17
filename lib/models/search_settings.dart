
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';


@immutable
class SearchSettings {

  final bool autoOpenBar;
  final bool showAllWhenNoQuery;
  final bool clearButtonExitWhenNoQuery;
  final bool fabEnabled;
  final bool fabMoveWithKeyboard;
  
  const SearchSettings({
    this.autoOpenBar=false,
    this.showAllWhenNoQuery=false,
    this.clearButtonExitWhenNoQuery=true,
    this.fabEnabled=true,
    this.fabMoveWithKeyboard=false,
  });

  SearchSettings copyWith({
    bool? autoOpenBar,
    bool? showAllWhenNoQuery,
    bool? clearButtonExitWhenNoQuery,
    bool? fabEnabled,
    bool? fabMoveWithKeyboard,
  }) => SearchSettings(
    autoOpenBar: autoOpenBar ?? this.autoOpenBar,
    showAllWhenNoQuery: showAllWhenNoQuery ?? this.showAllWhenNoQuery,
    clearButtonExitWhenNoQuery: clearButtonExitWhenNoQuery ?? this.clearButtonExitWhenNoQuery,
    fabEnabled: fabEnabled ?? this.fabEnabled,
    fabMoveWithKeyboard: fabMoveWithKeyboard ?? this.fabMoveWithKeyboard,
  );

  Map<String, dynamic> toMap() => {
    "autoOpenBar": autoOpenBar,
    "showAllWhenNoQuery": showAllWhenNoQuery,
    "clearButtonExitWhenNoQuery": clearButtonExitWhenNoQuery,
    "fabEnabled": fabEnabled,
    "fabMoveWithKeyboard": fabMoveWithKeyboard,
  };

  factory SearchSettings.fromMap(Map<String, dynamic> map) => SearchSettings(
    autoOpenBar: map["autoOpenBar"] ?? kDefaultSettings.search.autoOpenBar,
    showAllWhenNoQuery: map["showAllWhenNoQuery"]
      ?? kDefaultSettings.search.showAllWhenNoQuery,
    clearButtonExitWhenNoQuery: map["clearButtonExitWhenNoQuery"]
      ?? kDefaultSettings.search.clearButtonExitWhenNoQuery,
    fabEnabled: map["fabEnabled"] ?? kDefaultSettings.search.fabEnabled,
    fabMoveWithKeyboard: map["fabMoveWithKeyboard"]
      ?? kDefaultSettings.search.fabMoveWithKeyboard,
  );

  String toJson() => json.encode(toMap());

  factory SearchSettings.fromJson(String source) => SearchSettings.fromMap(json.decode(source));

  @override
  String toString() =>
    "SearchSettings(autoOpenBar: $autoOpenBar, showAllWhenNoQuery: $showAllWhenNoQuery, clearButtonExitWhenNoQuery: $clearButtonExitWhenNoQuery, fabEnabled: $fabEnabled, fabMoveWithKeyboard: $fabMoveWithKeyboard)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SearchSettings
      && other.autoOpenBar == autoOpenBar
      && other.showAllWhenNoQuery == showAllWhenNoQuery
      && other.clearButtonExitWhenNoQuery == clearButtonExitWhenNoQuery
      && other.fabEnabled == fabEnabled
      && other.fabMoveWithKeyboard == fabMoveWithKeyboard;
  }

  @override
  int get hashCode => autoOpenBar.hashCode
    ^ showAllWhenNoQuery.hashCode
    ^ clearButtonExitWhenNoQuery.hashCode
    ^ fabEnabled.hashCode
    ^ fabMoveWithKeyboard.hashCode;
}
