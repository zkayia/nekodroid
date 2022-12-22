
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/constants/home_anime_card_action.dart';
import 'package:nekodroid/constants/home_episode_card_action.dart';
import 'package:nekodroid/constants/nav_labels_mode.dart';
import 'package:nekodroid/models/app_settings.dart';


final settingsProv = StateNotifierProvider<_SettingsProvNotif, AppSettings>(
  (ref) => _SettingsProvNotif.loadFromHive(),
);

class _SettingsProvNotif extends StateNotifier<AppSettings> {

  _SettingsProvNotif(AppSettings settings) : super(settings);

  factory _SettingsProvNotif.loadFromHive() {
    final box = Hive.box("settings");
    return _SettingsProvNotif(
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

  // General
  
  set themeMode(ThemeMode value) => state = state.copyWith(
    general: state.general.copyWith(themeMode: value),
  );

  set useAmoled(bool value) => state = state.copyWith(
    general: state.general.copyWith(useAmoled: value),
  );

  set locale(String value) => state = state.copyWith(
    general: state.general.copyWith(locale: value),
  );

  set defaultPage(int value) => state = state.copyWith(
    general: state.general.copyWith(defaultPage: value),
  );

  set navLabelsMode(NavLabelsMode value) => state = state.copyWith(
    general: state.general.copyWith(navLabelsMode: value),
  );

  set enableNavbarSwipe(bool value) => state = state.copyWith(
    general: state.general.copyWith(enableNavbarSwipe: value),
  );

  set reverseNavbarSwipe(bool value) => state = state.copyWith(
    general: state.general.copyWith(reverseNavbarSwipe: value),
  );

  // Home

  set carouselColumnCount(int value) => state = state.copyWith(
    home: state.home.copyWith(carouselColumnCount: value),
  );

  set episodeCardPressAction(HomeEpisodeCardAction value) => state = state.copyWith(
    home: state.home.copyWith(episodeCardPressAction: value),
  );

  set episodeCardLongPressAction(HomeEpisodeCardAction value) => state = state.copyWith(
    home: state.home.copyWith(episodeCardLongPressAction: value),
  );

  set animeCardPressAction(HomeAnimeCardAction value) => state = state.copyWith(
    home: state.home.copyWith(animeCardPressAction: value),
  );

  set animeCardLongPressAction(HomeAnimeCardAction value) => state = state.copyWith(
    home: state.home.copyWith(animeCardLongPressAction: value),
  );

  // Library
  
  set enableTabbarScrolling(bool value) => state = state.copyWith(
    library: state.library.copyWith(enableTabbarScrolling: value),
  );

  set defaultTab(int value) => state = state.copyWith(
    library: state.library.copyWith(defaultTab: value),
  );
  
  set enableHistory(bool value) => state = state.copyWith(
    library: state.library.copyWith(enableHistory: value),
  );

  set enableFavorites(bool value) => state = state.copyWith(
    library: state.library.copyWith(enableFavorites: value),
  );

  // Search

  set autoOpenBar(bool value) => state = state.copyWith(
    search: state.search.copyWith(autoOpenBar: value),
  );

  set clearButtonExitWhenNoQuery(bool value) => state = state.copyWith(
    search: state.search.copyWith(clearButtonExitWhenNoQuery: value),
  );

  set fabEnabled(bool value) => state = state.copyWith(
    search: state.search.copyWith(fabEnabled: value),
  );

  set fabMoveWithKeyboard(bool value) => state = state.copyWith(
    search: state.search.copyWith(fabMoveWithKeyboard: value),
  );

  set showAllWhenNoQuery(bool value) => state = state.copyWith(
    search: state.search.copyWith(showAllWhenNoQuery: value),
  );

  // Anime

  set blurThumbs(bool value) => state = state.copyWith(
    anime: state.anime.copyWith(blurThumbs: value),
  );

  set blurThumbsSigma(int value) => state = state.copyWith(
    anime: state.anime.copyWith(blurThumbsSigma: value),
  );

  set episodeCacheExtent(int value) => state = state.copyWith(
    anime: state.anime.copyWith(episodeCacheExtent: value),
  );

  set keepEpisodesAlive(bool value) => state = state.copyWith(
    anime: state.anime.copyWith(keepEpisodesAlive: value),
  );

  // Player

  set confirmOnBackExit(bool value) => state = state.copyWith(
    player: state.player.copyWith(confirmOnBackExit: value),
  );

  set backExitDelay(int value) => state = state.copyWith(
    player: state.player.copyWith(backExitDuration: value),
  );

  set controlsBackgroundTransparency(int value) => state = state.copyWith(
    player: state.player.copyWith(controlsBackgroundTransparency: value),
  );

  set controlsDisplayDuration(int value) => state = state.copyWith(
    player: state.player.copyWith(controlsDisplayDuration: value),
  );

  set controlsPauseOnDisplay(bool value) => state = state.copyWith(
    player: state.player.copyWith(controlsPauseOnDisplay: value),
  );

  set epAutoMarkCompleted(bool value) => state = state.copyWith(
    player: state.player.copyWith(epAutoMarkCompleted: value),
  );

  set epAutoMarkCompletedThreshold(int value) => state = state.copyWith(
    player: state.player.copyWith(epAutoMarkCompletedThreshold: value),
  );

  set epContinueAtLastLocation(bool value) => state = state.copyWith(
    player: state.player.copyWith(epContinueAtLastLocation: value),
  );

  set introSkipTime(int value) => state = state.copyWith(
    player: state.player.copyWith(introSkipTime: value),
  );

  set quickSkipBackwardTime(int value) => state = state.copyWith(
    player: state.player.copyWith(quickSkipBackwardTime: value),
  );

  set quickSkipDisplayDuration(int value) => state = state.copyWith(
    player: state.player.copyWith(quickSkipDisplayDuration: value),
  );
  
  set quickSkipForwardTime(int value) => state = state.copyWith(
    player: state.player.copyWith(quickSkipForwardTime: value),
  );
}
