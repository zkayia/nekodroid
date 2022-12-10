
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/player/webview/providers/webview_controller.dart';
import 'package:nekodroid/routes/player/webview/providers/webview_is_loading.dart';


class WebviewPlayer extends ConsumerWidget {

  final Uri videoUrl;

  const WebviewPlayer({
    required this.videoUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Stack(
    alignment: Alignment.center,
    children: [
      const Positioned.fill(
        child: Material(
          color: Colors.black,
        ),
      ),
      Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: InAppWebView(
            key: GlobalKey(),
            initialUrlRequest: URLRequest(url: videoUrl),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                clearCache: true,
                disableHorizontalScroll: true,
                disableVerticalScroll: true,
                javaScriptCanOpenWindowsAutomatically: false,
                incognito: true,
                mediaPlaybackRequiresUserGesture: false,
                supportZoom: false,
                transparentBackground: true,
                useShouldOverrideUrlLoading: true,
              ),
              android: AndroidInAppWebViewOptions(
                clearSessionCache: true,
                databaseEnabled: false,
                domStorageEnabled: false,
                geolocationEnabled: false,
                useHybridComposition: true,
                thirdPartyCookiesEnabled: false,
                displayZoomControls: false,
                useWideViewPort: false,
                useShouldInterceptRequest: true,
                forceDark: _resolveForceDark(
                  ref.watch(settingsProv.select((v) => v.general.themeMode)),
                ),
              ),
            ),
            onWebViewCreated: (controller) async {
              ref.read(webviewControllerProv.notifier).update((state) => controller);
              controller
                ..addUserScript(
                  userScript: UserScript(
                    injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
                    source: await DefaultAssetBundle.of(context).loadString(
                      "assets/player/nekosama_buttons.user.js",
                    ),
                  ),
                )
                ..addUserScript(
                  userScript: UserScript(
                    injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
                    source: await DefaultAssetBundle.of(context).loadString(
                      "assets/player/adblock.js",
                    ),
                  ),
                );
            },
            onLoadStop: (controller, url) =>
              ref.read(webviewIsLoadingProv.notifier).update((state) => false),
            androidShouldInterceptRequest: (controller, request) async =>
              _keepRequest(request) ? null : WebResourceResponse(),
            shouldOverrideUrlLoading: (controller, action) async =>
              _keepRequest(action.request)
                ? NavigationActionPolicy.ALLOW
                : NavigationActionPolicy.CANCEL,
          ),
        ),
      ),
      if (ref.watch(webviewIsLoadingProv))
        const CircularProgressIndicator(),
    ],
  );

  bool _keepRequest(dynamic request) =>
    ["pstream.net", "gcdn.me"].any((e) => request.url?.host?.contains(e) ?? false)
      ? !["prebid", "ads"].any((e) => request.url?.host?.contains(e) ?? false)
      : request.headers?["origin"] == "https://www.pstream.net";
  
  AndroidForceDark _resolveForceDark(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.dark:
        return AndroidForceDark.FORCE_DARK_ON;
      case ThemeMode.light:
        return AndroidForceDark.FORCE_DARK_OFF;
      case ThemeMode.system:
        return AndroidForceDark.FORCE_DARK_AUTO;
    }
  }
}
