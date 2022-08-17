

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/helpers/nav_labels_mode.dart';
import 'package:nekodroid/models/app_settings.dart';


final settingsProvider = StateNotifierProvider<_SettingsProviderNotifier, AppSettings>(
  (ref) => _SettingsProviderNotifier.loadFromHive(),
);

class _SettingsProviderNotifier extends StateNotifier<AppSettings> {

  _SettingsProviderNotifier(AppSettings settings) : super(settings);

  factory _SettingsProviderNotifier.loadFromHive() {
    final box = Hive.box("settings");
    return _SettingsProviderNotifier(
      AppSettings.fromMap({
        for (final setting in kDefaultSettings.toMap().entries)
          setting.key: box.get(setting.key) ?? setting.value,
      }),
    );
  }

  Future<void> saveToHive() async => Hive.box("settings").putAll(state.toMap());

  set locale(String value) =>
    state = state.copyWith(locale: value);
  void resetLocale() =>
    state = state.copyWith(locale: kDefaultSettings.locale);
  
  set themeMode(ThemeMode value) =>
    state = state.copyWith(themeMode: value);
  void resetThemeMode() =>
    state = state.copyWith(themeMode: kDefaultSettings.themeMode);

  set useAmoled(bool value) =>
    state = state.copyWith(useAmoled: value);
  void resetUseAmoled() =>
    state = state.copyWith(useAmoled: kDefaultSettings.useAmoled);

  set defaultPage(int value) =>
    state = state.copyWith(defaultPage: value);
  void resetDefaultPage() =>
    state = state.copyWith(defaultPage: kDefaultSettings.defaultPage);

  set carouselItemCount(int value) =>
    state = state.copyWith(carouselItemCount: value);
  void resetCarouselItemCount() =>
    state = state.copyWith(carouselItemCount: kDefaultSettings.carouselItemCount);

  set secrecyEnabled(bool value) =>
    state = state.copyWith(secrecyEnabled: value);
  void resetSecrecyEnabled() =>
    state = state.copyWith(secrecyEnabled: kDefaultSettings.secrecyEnabled);
  void switchSecrecyEnabled() =>
    state = state.copyWith(secrecyEnabled: !state.secrecyEnabled);

  set blurThumbs(bool value) =>
    state = state.copyWith(blurThumbs: value);
  void resetBlurThumbs() =>
    state = state.copyWith(blurThumbs: kDefaultSettings.blurThumbs);

  set blurThumbsSigma(double value) =>
    state = state.copyWith(blurThumbsSigma: value);
  void resetBlurThumbsSigma() =>
    state = state.copyWith(blurThumbsSigma: kDefaultSettings.blurThumbsSigma);
  
  set navLabelsMode(NavLabelsMode value) =>
    state = state.copyWith(navLabelsMode: value);
  void resetNavLabelsMode() =>
    state = state.copyWith(navLabelsMode: kDefaultSettings.navLabelsMode);
}
