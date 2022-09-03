
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/extensions/locale.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/anime/anime.dart';
import 'package:nekodroid/routes/base.search/search.dart';
import 'package:nekodroid/routes/base/base.dart';
import 'package:nekodroid/routes/base.carousel_more/carousel_more.dart';
import 'package:nekodroid/routes/fullscreen_viewer/fullscreen_viewer.dart';
import 'package:nekodroid/routes/player/player.dart';
import 'package:nekodroid/routes/settings/settings.dart';

// import 'package:device_preview/device_preview.dart';


class App extends ConsumerWidget {

  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
    // // next 2 lines are related to the layout testing tool
    // useInheritedMediaQuery: true,
    // builder: DevicePreview.appBuilder,
    onGenerateTitle: (context) => context.tr.appTitle,
    debugShowCheckedModeBanner: false,
    theme: lightTheme,
    darkTheme: ref.watch(settingsProvider.select((value) => value.useAmoled))
      ? amoledTheme
      : darkTheme,
    themeMode: ref.watch(settingsProvider.select((value) => value.themeMode)),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: LocaleX.fromSettingString(
      ref.watch(settingsProvider.select((value) => value.locale)),
    )
      ?? LocaleX.fromString(Intl.systemLocale),
    builder: (context, child) => ScrollConfiguration(
      behavior: _NoOverscrollIndicatorScrollBehavior(),
      child: child!,
    ),
    initialRoute: "/base",
    routes: {
      "/anime": (context) => const AnimeRoute(),
      "/base": (context) => const BaseRoute(),
      "/base/carousel_more": (context) => const CarouselMoreRoute(),
      "/base/search": (context) => const SearchRoute(),
      "/fullscreen_viewer": (context) => const FullscreenViewerRoute(),
      "/player": (context) => const PlayerRoute(),
      "/settings": (context) => const SettingsRoute(),
    },
  );
}

class _NoOverscrollIndicatorScrollBehavior extends ScrollBehavior {
  
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}
