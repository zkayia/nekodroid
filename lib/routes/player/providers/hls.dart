
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';


final hlsProvider = FutureProvider.autoDispose.family<Map<String, List<int>>, HlsProviderData>(
	(ref, data) {
		final completer = Completer<Map<String, List<int>>>();
		final webview = _buildWebview(completer, data);
		ref.onDispose(() => webview.dispose());
		completer.future.then((_) => webview.dispose());
		Future.delayed(
			const Duration(milliseconds: kHeadlessWebviewMaxLifetime),
		).then((_) {
			webview.dispose();
			if (!completer.isCompleted) {
				completer.completeError(Exception("Unable to extract hls file url in time"));
			}
		});
		webview.run();
		return completer.future;
	},
); 

@immutable
class HlsProviderData {

	final Uri videoUrl;
	final AssetBundle assetBundle;

	const HlsProviderData({
		required this.videoUrl,
		required this.assetBundle,
	});

	@override
	String toString() => "HlsProviderData(videoUrl: $videoUrl, assetBundle: $assetBundle)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) return true;
		return other is HlsProviderData && other.videoUrl == videoUrl && other.assetBundle == assetBundle;
	}

	@override
	int get hashCode => videoUrl.hashCode ^ assetBundle.hashCode;
}

HeadlessInAppWebView _buildWebview(Completer<Map<String, List<int>>> completer, HlsProviderData data) {
	int qualitiesCount = 0;
	Map<String, List<int>> qualities = {};
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
				url.contains(RegExp("pstream.net/(m|h)/"))
				&& url.contains(".m3u8")
				&& request.readyState == AjaxRequestReadyState.DONE
			) {
				final data = request.responseText;
				if (data?.isNotEmpty ?? false) {
					if (url.contains("pstream.net/h/")) {
						qualities.putIfAbsent(
							request.url!.pathSegments.elementAt(1),
							() => utf8.encode(data!),
						);
						if (qualitiesCount != 0 && qualities.length == qualitiesCount) {
							completer.complete(qualities);
						}
					} else {
						final streamCount =  RegExp("#EXT-X-STREAM-INF").allMatches(data!).length;
						if (streamCount > 0) {
							qualitiesCount = streamCount;
						}
					}
				}
			}
			return AjaxRequestAction.PROCEED;
		},
		onConsoleMessage: (_, __) {},
		androidShouldInterceptRequest: (controller, request) async =>
			request.url.host.contains("pstream.net") && !completer.isCompleted
				? null
				: WebResourceResponse(),
		shouldOverrideUrlLoading: (controller, action) async => NavigationActionPolicy.CANCEL,
	);
}
