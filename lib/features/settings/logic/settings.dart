import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/core/utils/kv_db_utils.dart';
import 'package:nekosama/nekosama.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nekodroid/core/providers/db_kv.dart';

part 'settings.g.dart';

@riverpod
class Settings extends _$Settings {
  @override
  SettingsState build() {
    try {
      return SettingsState.fromDb(ref.read(dbKvProvider));
    } catch (_) {
      return _defaultSettings;
    }
  }

  void setThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);
    ref.read(dbKvProvider).setString(KvDbUtils.settingsThemeMode, themeMode.name);
    final isDarkTheme = themeMode == ThemeMode.system
        ? SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark
        : themeMode == ThemeMode.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: isDarkTheme ? Brightness.dark : Brightness.dark,
        statusBarIconBrightness: isDarkTheme ? Brightness.light : Brightness.dark,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDarkTheme ? Brightness.light : Brightness.dark,
      ),
    );
  }

  void toggleSearchSource(NSSources source, bool enabled) {
    final enabledSources = enabled ? state.searchSources.union({source}) : state.searchSources.difference({source});
    state = state.copyWith(searchSources: enabledSources);
    ref.read(dbKvProvider).setStringList(KvDbUtils.settingsSearchSources, [...enabledSources.map((e) => e.name)]);
  }

  void setPrivateBrowsingEnabled(bool enabled) => state = state.copyWith(privateBrowsingEnabled: enabled);
}

const _defaultSettings = SettingsState(
  themeMode: ThemeMode.system,
  searchSources: {...NSSources.values},
  privateBrowsingEnabled: false,
);

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Set<NSSources> searchSources;
  // SESSION
  final bool privateBrowsingEnabled;

  const SettingsState({
    required this.themeMode,
    required this.searchSources,
    required this.privateBrowsingEnabled,
  });

  factory SettingsState.fromDb(SharedPreferences db) {
    final searchSources = db.getStringList(KvDbUtils.settingsSearchSources);
    return SettingsState(
      themeMode: ThemeMode.values.firstWhere(
        (e) => e.name == db.getString(KvDbUtils.settingsThemeMode),
        orElse: () => _defaultSettings.themeMode,
      ),
      searchSources: searchSources == null
          ? _defaultSettings.searchSources
          : {...searchSources.map(NSSources.fromString).whereType<NSSources>()},
      privateBrowsingEnabled: _defaultSettings.privateBrowsingEnabled,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        searchSources,
        privateBrowsingEnabled,
      ];

  SettingsState copyWith({
    ThemeMode? themeMode,
    Set<NSSources>? searchSources,
    bool? privateBrowsingEnabled,
  }) =>
      SettingsState(
        themeMode: themeMode ?? this.themeMode,
        searchSources: searchSources ?? this.searchSources,
        privateBrowsingEnabled: privateBrowsingEnabled ?? this.privateBrowsingEnabled,
      );
}
