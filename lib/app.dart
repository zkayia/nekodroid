import 'package:after_layout/after_layout.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/providers/router.dart';
import 'package:nekodroid/core/providers/error.dart';
import 'package:nekodroid/core/utils/network.dart';
import 'package:nekodroid/core/utils/search_db.dart';
import 'package:nekodroid/features/settings/logic/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  final Locale? devicePreviewLocale;

  const App({this.devicePreviewLocale, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => _ProvidersInit(
        child: MaterialApp.router(
          useInheritedMediaQuery: devicePreviewLocale != null,
          title: "Nekodroid",
          debugShowCheckedModeBanner: false,
          routerConfig: ref.watch(routerProvider),
          theme: kLightTheme,
          darkTheme: kDarkTheme,
          themeMode: ref.watch(settingsProvider.select((v) => v.themeMode)),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: devicePreviewLocale ?? kAppLocale,
          supportedLocales: const [kAppLocale],
        ),
      );
}

class _ProvidersInit extends ConsumerStatefulWidget {
  final Widget child;

  const _ProvidersInit({required this.child});

  @override
  ConsumerState<_ProvidersInit> createState() => _ProvidersInitState();
}

class _ProvidersInitState extends ConsumerState<_ProvidersInit> with AfterLayoutMixin<_ProvidersInit> {
  @override
  void initState() {
    super.initState();
    final themeMode = ref.read(settingsProvider).themeMode;
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

  @override
  void afterFirstLayout(BuildContext context) async {
    ref.read(errorProvider.notifier).checkForErrors();
    Connectivity().onConnectivityChanged.listen((event) {
      ref.read(errorProvider.notifier).toggleError(
            const NoNetworkError(),
            set: !NetworkUtils.connectivityResultHasNetwork(event),
          );
    });
    SearchDbUtils.updateDb(ref);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
