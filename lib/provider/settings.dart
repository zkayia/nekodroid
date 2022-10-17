

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/constants/home_anime_card_action.dart';
import 'package:nekodroid/constants/home_episode_card_action.dart';
import 'package:nekodroid/constants/nav_labels_mode.dart';
import 'package:nekodroid/constants/search_filters_persist_mode.dart';
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

  // Session

  set privateBrowsingEnabled(bool value) => state = state.copyWith(
    session: state.session.copyWith(privateBrowsingEnabled: value),
  );
  void togglePrivateBrowsingEnabled() => state = state.copyWith(
    session: state.session.copyWith(
      privateBrowsingEnabled: !state.session.privateBrowsingEnabled,
    ),
  );
  void resetPrivateBrowsingEnabled() => state = state.copyWith(
    session: state.session.copyWith(
      privateBrowsingEnabled: kDefaultSettings.session.privateBrowsingEnabled,
    ),
  );

  // General
  
  set themeMode(ThemeMode value) => state = state.copyWith(
    general: state.general.copyWith(themeMode: value),
  );
  void resetThemeMode() => state = state.copyWith(
    general: state.general.copyWith(
      themeMode: kDefaultSettings.general.themeMode,
    ),
  );

  set useAmoled(bool value) => state = state.copyWith(
    general: state.general.copyWith(useAmoled: value),
  );
  void toggleUseAmoled() => state = state.copyWith(
    general: state.general.copyWith(
      useAmoled: !state.general.useAmoled,
    ),
  );
  void resetUseAmoled() => state = state.copyWith(
    general: state.general.copyWith(
      useAmoled: kDefaultSettings.general.useAmoled,
    ),
  );

  set locale(String value) => state = state.copyWith(
    general: state.general.copyWith(locale: value),
  );
  void resetLocale() => state = state.copyWith(
    general: state.general.copyWith(
      locale: kDefaultSettings.general.locale,
    ),
  );

  set defaultPage(int value) => state = state.copyWith(
    general: state.general.copyWith(defaultPage: value),
  );
  void resetDefaultPage() => state = state.copyWith(
    general: state.general.copyWith(
      defaultPage: kDefaultSettings.general.defaultPage,
    ),
  );

  set navLabelsMode(NavLabelsMode value) => state = state.copyWith(
    general: state.general.copyWith(navLabelsMode: value),
  );
  void resetNavLabelsMode() => state = state.copyWith(
    general: state.general.copyWith(
      navLabelsMode: kDefaultSettings.general.navLabelsMode,
    ),
  );

  set enableNavbarSwipe(bool value) => state = state.copyWith(
    general: state.general.copyWith(enableNavbarSwipe: value),
  );
  void toggleEnableNavbarSwipe() => state = state.copyWith(
    general: state.general.copyWith(
      enableNavbarSwipe: !state.general.enableNavbarSwipe,
    ),
  );
  void resetEnableNavbarSwipe() => state = state.copyWith(
    general: state.general.copyWith(
      enableNavbarSwipe: kDefaultSettings.general.enableNavbarSwipe,
    ),
  );

  set reverseNavbarSwipe(bool value) => state = state.copyWith(
    general: state.general.copyWith(reverseNavbarSwipe: value),
  );
  void toggleReverseNavbarSwipe() => state = state.copyWith(
    general: state.general.copyWith(
      reverseNavbarSwipe: !state.general.reverseNavbarSwipe,
    ),
  );
  void resetReverseNavbarSwipe() => state = state.copyWith(
    general: state.general.copyWith(
      reverseNavbarSwipe: kDefaultSettings.general.reverseNavbarSwipe,
    ),
  );

  // Home

  set carouselColumnCount(int value) => state = state.copyWith(
    home: state.home.copyWith(carouselColumnCount: value),
  );
  void resetCarouselColumnCount() => state = state.copyWith(
    home: state.home.copyWith(
      carouselColumnCount: kDefaultSettings.home.carouselColumnCount,
    ),
  );

  set episodeCardPressAction(HomeEpisodeCardAction value) => state = state.copyWith(
    home: state.home.copyWith(episodeCardPressAction: value),
  );
  void resetEpisodeCardPressAction() => state = state.copyWith(
    home: state.home.copyWith(
      episodeCardPressAction: kDefaultSettings.home.episodeCardPressAction,
    ),
  );

  set episodeCardLongPressAction(HomeEpisodeCardAction value) => state = state.copyWith(
    home: state.home.copyWith(episodeCardLongPressAction: value),
  );
  void resetEpisodeCardLongPressAction() => state = state.copyWith(
    home: state.home.copyWith(
      episodeCardLongPressAction: kDefaultSettings.home.episodeCardLongPressAction,
    ),
  );

  set animeCardPressAction(HomeAnimeCardAction value) => state = state.copyWith(
    home: state.home.copyWith(animeCardPressAction: value),
  );
  void resetAnimeCardPressAction() => state = state.copyWith(
    home: state.home.copyWith(
      animeCardPressAction: kDefaultSettings.home.animeCardPressAction,
    ),
  );

  set animeCardLongPressAction(HomeAnimeCardAction value) => state = state.copyWith(
    home: state.home.copyWith(animeCardLongPressAction: value),
  );
  void resetAnimeCardLongPressAction() => state = state.copyWith(
    home: state.home.copyWith(
      animeCardLongPressAction: kDefaultSettings.home.animeCardLongPressAction,
    ),
  );

  // Library
  
  set enableTabbarScrolling(bool value) => state = state.copyWith(
    library: state.library.copyWith(enableTabbarScrolling: value),
  );
  void toggleEnableTabbarScrolling() => state = state.copyWith(
    library: state.library.copyWith(
      enableTabbarScrolling: !state.library.enableTabbarScrolling,
    ),
  );
  void resetEnableTabbarScrolling() => state = state.copyWith(
    library: state.library.copyWith(
      enableTabbarScrolling: kDefaultSettings.library.enableTabbarScrolling,
    ),
  );

  set defaultTab(int value) => state = state.copyWith(
    library: state.library.copyWith(defaultTab: value),
  );
  void resetDefaultTab() => state = state.copyWith(
    library: state.library.copyWith(
      defaultTab: kDefaultSettings.library.defaultTab,
    ),
  );
  
  set enableHistory(bool value) => state = state.copyWith(
    library: state.library.copyWith(enableHistory: value),
  );
  void toggleEnableHistory() => state = state.copyWith(
    library: state.library.copyWith(
      enableHistory: !state.library.enableHistory,
    ),
  );
  void resetEnableHistory() => state = state.copyWith(
    library: state.library.copyWith(
      enableHistory: kDefaultSettings.library.enableHistory,
    ),
  );

  set enableFavorites(bool value) => state = state.copyWith(
    library: state.library.copyWith(enableFavorites: value),
  );
  void toggleEnableFavorites() => state = state.copyWith(
    library: state.library.copyWith(
      enableFavorites: !state.library.enableFavorites,
    ),
  );
  void resetEnableFavorites() => state = state.copyWith(
    library: state.library.copyWith(
      enableFavorites: kDefaultSettings.library.enableFavorites,
    ),
  );

  // Search

  set autoOpenBar(bool value) => state = state.copyWith(
    search: state.search.copyWith(autoOpenBar: value),
  );
  void toggleAutoOpenBar() => state = state.copyWith(
    search: state.search.copyWith(
      autoOpenBar: !state.search.autoOpenBar,
    ),
  );
  void resetAutoOpenBar() => state = state.copyWith(
    search: state.search.copyWith(
      autoOpenBar: kDefaultSettings.search.autoOpenBar,
    ),
  );

  set clearButtonExitWhenNoQuery(bool value) => state = state.copyWith(
    search: state.search.copyWith(clearButtonExitWhenNoQuery: value),
  );
  void toggleClearButtonExitWhenNoQuery() => state = state.copyWith(
    search: state.search.copyWith(
      clearButtonExitWhenNoQuery: !state.search.clearButtonExitWhenNoQuery,
    ),
  );
  void resetAutoOpenClearButtonExitWhenNoQuery() => state = state.copyWith(
    search: state.search.copyWith(
      clearButtonExitWhenNoQuery: kDefaultSettings.search.clearButtonExitWhenNoQuery,
    ),
  );

  set fabEnabled(bool value) => state = state.copyWith(
    search: state.search.copyWith(fabEnabled: value),
  );
  void toggleFabEnabled() => state = state.copyWith(
    search: state.search.copyWith(
      fabEnabled: !state.search.fabEnabled,
    ),
  );
  void resetFabEnabledoOpenBar() => state = state.copyWith(
    search: state.search.copyWith(
      fabEnabled: kDefaultSettings.search.fabEnabled,
    ),
  );

  set fabMoveWithKeyboard(bool value) => state = state.copyWith(
    search: state.search.copyWith(fabMoveWithKeyboard: value),
  );
  void toggleFabMoveWithKeyboard() => state = state.copyWith(
    search: state.search.copyWith(
      fabMoveWithKeyboard: !state.search.fabMoveWithKeyboard,
    ),
  );
  void resetAFabMoveWithKeyboard() => state = state.copyWith(
    search: state.search.copyWith(
      fabMoveWithKeyboard: kDefaultSettings.search.fabMoveWithKeyboard,
    ),
  );

  set persistFiltersMode(SearchFiltersPersistMode value) => state = state.copyWith(
    search: state.search.copyWith(persistFiltersMode: value),
  );
  void resetPersistFiltersMode() => state = state.copyWith(
    search: state.search.copyWith(
      persistFiltersMode: kDefaultSettings.search.persistFiltersMode,
    ),
  );

  set showAllWhenNoQuery(bool value) => state = state.copyWith(
    search: state.search.copyWith(showAllWhenNoQuery: value),
  );
  void toggleShowAllWhenNoQuery() => state = state.copyWith(
    search: state.search.copyWith(
      showAllWhenNoQuery: !state.search.showAllWhenNoQuery,
    ),
  );
  void resetShowAllWhenNoQuery() => state = state.copyWith(
    search: state.search.copyWith(
      showAllWhenNoQuery: kDefaultSettings.search.showAllWhenNoQuery,
    ),
  );

  // Anime

  set autoAddToWatching(bool value) => state = state.copyWith(
    anime: state.anime.copyWith(autoAddToWatching: value),
  );
  void toggleAutoAddToWatching() => state = state.copyWith(
    anime: state.anime.copyWith(
      autoAddToWatching: !state.anime.autoAddToWatching,
    ),
  );
  void resetAutoAddToWatching() => state = state.copyWith(
    anime: state.anime.copyWith(
      autoAddToWatching: kDefaultSettings.anime.autoAddToWatching,
    ),
  );

  set blurThumbs(bool value) => state = state.copyWith(
    anime: state.anime.copyWith(blurThumbs: value),
  );
  void toggleBlurThumbs() => state = state.copyWith(
    anime: state.anime.copyWith(
      blurThumbs: !state.anime.blurThumbs,
    ),
  );
  void resetBlurThumbs() => state = state.copyWith(
    anime: state.anime.copyWith(
      blurThumbs: kDefaultSettings.anime.blurThumbs,
    ),
  );

  set blurThumbsSigma(int value) => state = state.copyWith(
    anime: state.anime.copyWith(blurThumbsSigma: value),
  );
  void resetBlurThumbsSigma() => state = state.copyWith(
    anime: state.anime.copyWith(
      blurThumbsSigma: kDefaultSettings.anime.blurThumbsSigma,
    ),
  );

  set lazyLoadItemCount(int value) => state = state.copyWith(
    anime: state.anime.copyWith(lazyLoadItemCount: value),
  );
  void resetLazyLoadItemCount() => state = state.copyWith(
    anime: state.anime.copyWith(
      lazyLoadItemCount: kDefaultSettings.anime.lazyLoadItemCount,
    ),
  );

  // Player

  set confirmOnBackExit(bool value) => state = state.copyWith(
    player: state.player.copyWith(confirmOnBackExit: value),
  );
  void toggleConfirmOnBackExit() => state = state.copyWith(
    player: state.player.copyWith(
      confirmOnBackExit: !state.player.confirmOnBackExit,
    ),
  );
  void resetConfirmOnBackExit() => state = state.copyWith(
    player: state.player.copyWith(
      confirmOnBackExit: kDefaultSettings.player.confirmOnBackExit,
    ),
  );

  set backExitDelay(int value) => state = state.copyWith(
    player: state.player.copyWith(backExitDuration: value),
  );
  void resetBackExitDelay() => state = state.copyWith(
    player: state.player.copyWith(
      backExitDuration: kDefaultSettings.player.backExitDuration,
    ),
  );

  set controlsBackgroundTransparency(int value) => state = state.copyWith(
    player: state.player.copyWith(controlsBackgroundTransparency: value),
  );
  void resetControlsBackgroundTransparency() => state = state.copyWith(
    player: state.player.copyWith(
      controlsBackgroundTransparency: kDefaultSettings.player.controlsBackgroundTransparency,
    ),
  );

  set controlsDisplayDuration(int value) => state = state.copyWith(
    player: state.player.copyWith(controlsDisplayDuration: value),
  );
  void resetControlsDisplayDuration() => state = state.copyWith(
    player: state.player.copyWith(
      controlsDisplayDuration: kDefaultSettings.player.controlsDisplayDuration,
    ),
  );

  set controlsPauseOnDisplay(bool value) => state = state.copyWith(
    player: state.player.copyWith(controlsPauseOnDisplay: value),
  );
  void toggleControlsPauseOnDisplay() => state = state.copyWith(
    player: state.player.copyWith(
      controlsPauseOnDisplay: !state.player.controlsPauseOnDisplay,
    ),
  );
  void resetControlsPauseOnDisplay() => state = state.copyWith(
    player: state.player.copyWith(
      controlsPauseOnDisplay: kDefaultSettings.player.controlsPauseOnDisplay,
    ),
  );

  set epAutoMarkCompleted(bool value) => state = state.copyWith(
    player: state.player.copyWith(epAutoMarkCompleted: value),
  );
  void toggleEpAutoMarkCompleted() => state = state.copyWith(
    player: state.player.copyWith(
      epAutoMarkCompleted: !state.player.epAutoMarkCompleted,
    ),
  );
  void resetEpAutoMarkCompleted() => state = state.copyWith(
    player: state.player.copyWith(
      epAutoMarkCompleted: kDefaultSettings.player.epAutoMarkCompleted,
    ),
  );

  set epAutoMarkCompletedThreshold(int value) => state = state.copyWith(
    player: state.player.copyWith(epAutoMarkCompletedThreshold: value),
  );
  void resetEpAutoMarkCompletedThreshold() => state = state.copyWith(
    player: state.player.copyWith(
      epAutoMarkCompletedThreshold: kDefaultSettings.player.epAutoMarkCompletedThreshold,
    ),
  );

  set epContinueAtLastLocation(bool value) => state = state.copyWith(
    player: state.player.copyWith(epContinueAtLastLocation: value),
  );
  void toggleEpContinueAtLastLocation() => state = state.copyWith(
    player: state.player.copyWith(
      epContinueAtLastLocation: !state.player.epContinueAtLastLocation,
    ),
  );
  void resetEpContinueAtLastLocation() => state = state.copyWith(
    player: state.player.copyWith(
      epContinueAtLastLocation: kDefaultSettings.player.epContinueAtLastLocation,
    ),
  );

  set introSkipTime(int value) => state = state.copyWith(
    player: state.player.copyWith(introSkipTime: value),
  );
  void resetIntroSkipTime() => state = state.copyWith(
    player: state.player.copyWith(
      introSkipTime: kDefaultSettings.player.introSkipTime,
    ),
  );

  set quickSkipBackwardTime(int value) => state = state.copyWith(
    player: state.player.copyWith(quickSkipBackwardTime: value),
  );
  void resetQuickSkipBackwardTime() => state = state.copyWith(
    player: state.player.copyWith(
      quickSkipBackwardTime: kDefaultSettings.player.quickSkipBackwardTime,
    ),
  );

  set quickSkipDisplayDuration(int value) => state = state.copyWith(
    player: state.player.copyWith(quickSkipDisplayDuration: value),
  );
  void resetQuickSkipDisplayDuration() => state = state.copyWith(
    player: state.player.copyWith(
      quickSkipDisplayDuration: kDefaultSettings.player.quickSkipDisplayDuration,
    ),
  );
  
  set quickSkipForwardTime(int value) => state = state.copyWith(
    player: state.player.copyWith(quickSkipForwardTime: value),
  );
  void resetQuickSkipForwardTime() => state = state.copyWith(
    player: state.player.copyWith(
      quickSkipForwardTime: kDefaultSettings.player.quickSkipForwardTime,
    ),
  );
}
