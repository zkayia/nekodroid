import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nekodroid/features/player/logic/player_value.dart';
import 'package:nekodroid/features/player/logic/show_controls.dart';
import 'package:nekodroid/features/player/logic/web_msg_supported.dart';
import 'package:nekodroid/features/player/logic/webview_channel_port.dart';
import 'package:nekodroid/features/player/logic/webview.dart';

class PlayerWebview extends ConsumerWidget {
  final Uri url;
  final void Function(InAppWebViewController controller)? onWebviewCreated;
  final void Function(InAppWebViewController controller)? onMessageChannelSetup;

  const PlayerWebview({
    required this.url,
    this.onWebviewCreated,
    this.onMessageChannelSetup,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => AbsorbPointer(
        absorbing: ref.watch(webMsgSupportedProvider),
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri.uri(url)),
          gestureRecognizers: const {},
          initialSettings: InAppWebViewSettings(
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
            safeBrowsingEnabled: false,
            overScrollMode: OverScrollMode.NEVER,
          ),
          pullToRefreshController: PullToRefreshController(
            onRefresh: () => ref.read(webviewProvider).controller?.reload(),
            settings: PullToRefreshSettings(color: Theme.of(context).colorScheme.primary),
          ),
          onWebViewCreated: (controller) async {
            ref.read(webviewProvider.notifier).setController(controller);
            if (ref.read(webMsgSupportedProvider)) {
              final assetBundle = DefaultAssetBundle.of(context);
              for (final script in const ["webview_channel", "webview_tweaks"]) {
                controller.addUserScript(
                  userScript: UserScript(
                    injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
                    source: await assetBundle.loadString("assets/js/$script.js"),
                  ),
                );
              }
            }
            onWebviewCreated?.call(controller);
          },
          onLoadStart: (controller, url) => ref.read(webviewProvider.notifier).setLoading(true),
          onLoadStop: (controller, url) async {
            ref.read(webviewProvider.notifier).setLoading(false);
            if (ref.read(webMsgSupportedProvider)) {
              final webMessageChannel = await controller.createWebMessageChannel();
              if (webMessageChannel != null) {
                await webMessageChannel.port1.setWebMessageCallback((message) {
                  if (message == null) {
                    return;
                  }
                  final playerValue = PlayerValueState.fromJson(message.data);
                  // if (playerValue.error != null) {
                  //   ref.read(playerErrorsProv.notifier).update(
                  //         (state) => [...state, playerValue.error!],
                  //       );
                  // }
                  if (playerValue.ended) {
                    ref.read(showControlsProvider.notifier).set(true);
                  }
                  ref.read(playerValueProvider.notifier).set(playerValue);
                });
                ref.read(webviewChannelPortProvider.notifier).setPort(webMessageChannel.port1);
                await ref.read(webviewChannelPortProvider.notifier).initChannel(
                      webviewController: controller,
                      remotePort: webMessageChannel.port2,
                    );
                onMessageChannelSetup?.call(controller);
              }
            } else {
              Fluttertoast.showToast(msg: "Messages web non supporté");
            }
          },
          shouldInterceptRequest: (controller, request) async => _shouldKeepRequest(request.url) ? null : WebResourceResponse(),
          shouldOverrideUrlLoading: (controller, action) async =>
              _shouldKeepRequest(action.request.url) ? NavigationActionPolicy.ALLOW : NavigationActionPolicy.CANCEL,
        ),
      );

  bool _shouldKeepRequest(Uri? url) => url?.host == null ||
          [
            "www.pstream.net",
            "gcdn.me",
            "fusevideo.net",
            "fusevideo.io",
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
}
