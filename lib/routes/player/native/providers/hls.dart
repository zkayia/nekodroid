
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/models/hls_prov_data.dart';
import 'package:path_provider/path_provider.dart';


final hlsProv = FutureProvider.autoDispose.family<Map<String, File>, HlsProvData>(
  (ref, data) {
    final bytesCompleter = Completer<Map<String, List<int>>>();
    final filesCompleter = Completer<Map<String, File>>();
    final webview = _buildWebview(bytesCompleter, data);
    ref.onDispose(webview.dispose);
    bytesCompleter.future
      ..then(
        (value) async {
          if (value.isEmpty) {
            return filesCompleter.completeError(Exception("no hls stream found"));
          }
          final tempdir = await getTemporaryDirectory();
          final Map<String, File> result = {};
          for (final entry in value.entries) {
            final tempfile = File(
              "${tempdir.path}/nekodroid_nativeplayer_${DateTime.now().millisecondsSinceEpoch}.m3u8",
            );
            await tempfile.writeAsBytes(entry.value, flush: true);
            result.putIfAbsent(entry.key, () => tempfile);
          }
          filesCompleter.complete(result);
        },
        onError: (error, stackTrace) => filesCompleter.completeError(error, stackTrace),
      )
    ..whenComplete(webview.dispose);
    Future.delayed(
      const Duration(milliseconds: kHeadlessWebviewMaxLifetime),
    ).then((_) {
      final exception = Exception("HLS stream scrapper timed out.");
      webview.dispose();
      if (!bytesCompleter.isCompleted) {
        bytesCompleter.completeError(exception);
      }
      if (!filesCompleter.isCompleted) {
        filesCompleter.completeError(exception);
      }
    });
    webview.run();
    return filesCompleter.future;
  },
);

HeadlessInAppWebView _buildWebview(
  Completer<Map<String, List<int>>> bytesCompleter,
  HlsProvData data,
) {
  final qualitiesCount = Completer<int>();
  final Map<String, List<int>> qualities = {};
  return HeadlessInAppWebView(
    initialUrlRequest: URLRequest(url: data.videoUrl),
    initialOptions: InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptCanOpenWindowsAutomatically: false,
        incognito: true,
        mediaPlaybackRequiresUserGesture: false,
        useShouldOverrideUrlLoading: true,
        useShouldInterceptAjaxRequest: true,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
        thirdPartyCookiesEnabled: false,
        useShouldInterceptRequest: true,
      ),
    ),
    onWebViewCreated: (controller) async => controller
      ..addUserScript(
        userScript: UserScript(
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
          source: await data.assetBundle.loadString(
            "assets/player/adblock.js",
          ),
        ),
      )
      ..addUserScript(
        userScript: UserScript(
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
          source: await data.assetBundle.loadString(
            "assets/player/launch_player.js",
          ),
        ),
      ),
    onAjaxProgress: (controller, request) async {
      final url = request.url.toString();
      if (
        url.contains(RegExp(r"pstream.net\/(m|h)\/.*\.m3u8"))
        && request.readyState == AjaxRequestReadyState.DONE
      ) {
        final data = request.responseText;
        if (data?.isNotEmpty ?? false) {
          if (url.contains("pstream.net/h/")) {
            qualities.putIfAbsent(
              request.url!.pathSegments.elementAt(1),
              () => utf8.encode(data!),
            );
            if (
              qualitiesCount.isCompleted
              && !bytesCompleter.isCompleted
              && (await qualitiesCount.future) == qualities.length
            ) {
              bytesCompleter.complete(qualities);
            }
          } else if (!qualitiesCount.isCompleted) {
            final streams = RegExp(r"https.*\/h\/(\d+).*").allMatches(data!);
            if (streams.isNotEmpty) {
              qualitiesCount.complete(streams.length);
            }
          }
        }
      }
      return AjaxRequestAction.PROCEED;
    },
    androidShouldInterceptRequest: (controller, request) async =>
      request.url.host.contains("pstream.net") && !bytesCompleter.isCompleted
        ? null
        : WebResourceResponse(),
    shouldOverrideUrlLoading: (controller, action) async => NavigationActionPolicy.CANCEL,
  );
}
