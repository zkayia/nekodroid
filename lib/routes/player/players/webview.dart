
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/provider/settings.dart';


/* CONSTANTS */




/* MODELS */




/* PROVIDERS */

final _webviewIsLoadingProvider = StateProvider.autoDispose<bool>(
  (ref) => true,
);

final _webviewControllerProvider = StateProvider.autoDispose<InAppWebViewController?>(
  (ref) => null,
);


/* MISC */




/* WIDGETS */

class WebviewPlayer extends ConsumerStatefulWidget {

  final Uri videoUrl;

  const WebviewPlayer({
    required this.videoUrl,
    super.key,
  });

  @override
  WebviewPlayerState createState() => WebviewPlayerState();
}

class WebviewPlayerState extends ConsumerState<WebviewPlayer> {

  @override
  void dispose() {
    ref.read(_webviewControllerProvider)?.evaluateJavascript(
      source: "document.exitFullscreen();",
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.center,
    children: [
      InAppWebView(
        key: GlobalKey(),
        initialUrlRequest: URLRequest(url: widget.videoUrl),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
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
            useHybridComposition: true,
            thirdPartyCookiesEnabled: false,
            displayZoomControls: false,
            useWideViewPort: false,
            useShouldInterceptRequest: true,
            forceDark: _resolveForceDark(
              ref.watch(settingsProvider.select((v) => v.general.themeMode)),
            ),
          ),
        ),
        onWebViewCreated: (controller) async {
          ref.read(_webviewControllerProvider.notifier).update((state) => controller);
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
          ref.read(_webviewIsLoadingProvider.notifier).update((state) => false),
        androidShouldInterceptRequest: (controller, request) async =>
          _keepRequest(request) ? null : WebResourceResponse(),
        shouldOverrideUrlLoading: (controller, action) async =>
          _keepRequest(action.request)
            ? NavigationActionPolicy.ALLOW
            : NavigationActionPolicy.CANCEL,
      ),
      if (ref.watch(_webviewIsLoadingProvider))
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
