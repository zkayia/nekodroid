
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/models/player_value.dart';
import 'package:nekodroid/routes/player/providers/player_controls.dart';
import 'package:nekodroid/routes/player/providers/webview_controller.dart';
import 'package:nekodroid/routes/player/providers/player_errors.dart';
import 'package:nekodroid/routes/player/providers/webview_is_loading.dart';
import 'package:nekodroid/routes/player/providers/webview_channel_port.dart';
import 'package:nekodroid/routes/player/providers/player_value.dart';


class PlayerWebview extends ConsumerWidget {

  final GlobalKey webviewKey;
  final void Function(InAppWebViewController controller)? onWebviewCreated;
  final void Function(InAppWebViewController controller)? onMessageChannelSetup;

  const PlayerWebview({
    required this.webviewKey,
    this.onWebviewCreated,
    this.onMessageChannelSetup,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => AbsorbPointer(
    child: InAppWebView(
      key: webviewKey,
      initialUrlRequest: URLRequest(url: null),
      gestureRecognizers: const {},
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
          cacheEnabled: false,
          verticalScrollBarEnabled: false,
          horizontalScrollBarEnabled: false,
          disableContextMenu: true,
        ),
        android: AndroidInAppWebViewOptions(
          clearSessionCache: true,
          databaseEnabled: false,
          domStorageEnabled: false,
          geolocationEnabled: false,
          useHybridComposition: true,
          thirdPartyCookiesEnabled: false,
          displayZoomControls: false,
          builtInZoomControls: false,
          useWideViewPort: false,
          useShouldInterceptRequest: true,
          //TODO: make this a setting
          safeBrowsingEnabled: false,
          overScrollMode: AndroidOverScrollMode.OVER_SCROLL_NEVER,
          // forceDark: _resolveForceDark(
          //   ref.watch(settingsProv.select((v) => v.general.themeMode)),
          // ),
        ),
      ),
      pullToRefreshController: PullToRefreshController(
        onRefresh: () => ref.read(webviewControllerProv)?.reload(),
        options: PullToRefreshOptions(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onWebViewCreated: (controller) async {
        ref.read(webviewControllerProv.notifier).update((_) => controller);
        controller
          ..addUserScript(
            userScript: UserScript(
              injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
              source: await DefaultAssetBundle.of(context).loadString(
                "assets/player/webview_channel.js",
              ),
            ),
          )
          ..addUserScript(
            userScript: UserScript(
              injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
              source: await DefaultAssetBundle.of(context).loadString(
                "assets/player/webview_tweaks.js",
              ),
            ),
          );
        onWebviewCreated?.call(controller);
      },
      onLoadStart: (controller, url) =>
        ref.read(webviewIsLoadingProv.notifier).update((_) => true),
      onLoadStop: (controller, url) async {
        ref.read(webviewIsLoadingProv.notifier).update((_) => false);
        if (await _areWebMessageSupported()) {
          final webMessageChannel = await controller.createWebMessageChannel();
          if (webMessageChannel != null) {
            webMessageChannel.port1.setWebMessageCallback((message) {
              if (message == null) {
                return;
              }
              final playerValue = PlayerValue.fromJson(message);
              if (playerValue.error != null) {
                ref.read(playerErrorsProv.notifier).update(
                  (state) => [...state, playerValue.error!],
                );
              }
              if (playerValue.ended) {
                ref.read(playerControlsProv.notifier).videoDone();
              }
              ref.read(playerControlsProv.notifier).isPlaying = !playerValue.paused;
              ref.read(playerValueProv.notifier).update((_) => playerValue);
            });
            ref.read(webviewChannelPortProv.notifier)
              ..port = webMessageChannel.port1
              ..initChannel(
                webviewController: controller,
                remotePort: webMessageChannel.port2,
              );
            onMessageChannelSetup?.call(controller);
          }
        }
      },
      androidShouldInterceptRequest: (controller, request) async =>
        _shouldKeepRequest(request.url) ? null : WebResourceResponse(),
      shouldOverrideUrlLoading: (controller, action) async =>
        _shouldKeepRequest(action.request.url)
          ? NavigationActionPolicy.ALLOW
          : NavigationActionPolicy.CANCEL,
    ),
  );

  bool _shouldKeepRequest(Uri? url) => url?.host == null || [
    "www.pstream.net",
    "gcdn.me",
    "fusevideo.net",
    "reacdn.net",
  ].any((e) => url!.host.contains(e))
    ? ![
        "prebid",
        "ads",
        "boot",
        "event",
      ].any((e) => url!.path.contains(e))
    : false;
    // request.headers?["origin"] == "https://${videoUrl.host}"
  
  Future<bool> _areWebMessageSupported() async => Platform.isAndroid
    ? (
      await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.POST_WEB_MESSAGE,
      )
      && await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.CREATE_WEB_MESSAGE_CHANNEL,
      )
    )
    : true;
}
