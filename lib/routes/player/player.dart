
import 'package:boxicons/boxicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/player/providers/video.dart';
import 'package:nekodroid/routes/player/providers/webview_controller.dart';
import 'package:nekodroid/routes/player/providers/webview_loading.dart';
import 'package:nekodroid/routes/player/providers/webview_pop_time.dart';
import 'package:nekodroid/widgets/large_icon.dart';
import 'package:nekosama_dart/nekosama_dart.dart';


class PlayerRoute extends ConsumerWidget {

	const PlayerRoute({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
		SystemChrome.setPreferredOrientations([
			DeviceOrientation.portraitDown,
			DeviceOrientation.portraitUp,
			DeviceOrientation.landscapeLeft,
			DeviceOrientation.landscapeRight,
		]);
		return SafeArea(
			child: Scaffold(
				resizeToAvoidBottomInset: false,
				body: WillPopScope(
					onWillPop: () async {
						final current = DateTime.now().millisecondsSinceEpoch;
						if (current - ref.read(webviewPopTimeProvider) > kWebviewPopDelay) {
							ref.read(webviewPopTimeProvider.notifier).update((state) => current);
							Fluttertoast.showToast(
								msg: "confirm-exit".tr(),
								toastLength: Toast.LENGTH_SHORT,
								gravity: ToastGravity.BOTTOM,
								backgroundColor: Theme.of(context).colorScheme.background,
								textColor: Theme.of(context).textTheme.bodyMedium?.color,
							);
							return false;
						}
						ref.read(webviewControllerProvider)?.evaluateJavascript(source: "document.exitFullscreen();");
						await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
						await SystemChrome.setPreferredOrientations([
							DeviceOrientation.portraitDown,
							DeviceOrientation.portraitUp,
						]);
						return true;
					},
					child: Center(
						child: ref.watch(
							videoProvider(ModalRoute.of(context)!.settings.arguments as NSEpisode),
						).when(
							loading: () => const CircularProgressIndicator(),
							error: (err, stackTrace) => const LargeIcon(Boxicons.bx_error_circle),
							data: (data) => Stack(
								alignment: Alignment.center,
								children: [
									InAppWebView(
										key: GlobalKey(),
										initialUrlRequest: URLRequest(url: data),
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
													ref.watch(settingsProvider.select((value) => value.themeMode)),
												),
											),
										),
										onWebViewCreated: (controller) async {
											ref.read(webviewControllerProvider.notifier).update((state) => controller);
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
											ref.read(webviewLoadingProvider.notifier).update((state) => false),
										androidShouldInterceptRequest: (controller, request) async =>
											_keepRequest(request) ? null : WebResourceResponse(),
										shouldOverrideUrlLoading: (controller, action) async =>
											_keepRequest(action.request)
												? NavigationActionPolicy.ALLOW
												: NavigationActionPolicy.CANCEL,
									),
									if (ref.watch(webviewLoadingProvider))
										const CircularProgressIndicator(),
								],
							),
						),
					),
				),
			),
		);
	}

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
