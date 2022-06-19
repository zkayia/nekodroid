
import 'dart:convert';

import 'package:better_player/better_player.dart';
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/player/providers/hls.dart';
import 'package:nekodroid/routes/player/providers/video.dart';
import 'package:nekodroid/routes/player/providers/webview_controller.dart';
import 'package:nekodroid/routes/player/providers/webview_loading.dart';
import 'package:nekodroid/widgets/generic_route.dart';
import 'package:nekodroid/widgets/large_icon.dart';
import 'package:nekosama_dart/nekosama_dart.dart';


enum PlayerType {webview, native}

@immutable
class PlayerRouteParameters {

	final NSEpisode episode;
	final PlayerType playerType;

	const PlayerRouteParameters({
		required this.episode,
		required this.playerType,
	});
}

class PlayerRoute extends ConsumerStatefulWidget {

	const PlayerRoute({super.key});

	@override
	PlayerRouteState createState() => PlayerRouteState();
}

class PlayerRouteState extends ConsumerState<PlayerRoute> {

	@override
	void initState() {
		// SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
		// SystemChrome.setPreferredOrientations([
		// 	DeviceOrientation.landscapeLeft,
		// 	DeviceOrientation.landscapeRight,
		// ]);
		super.initState();
	}

	@override
	void dispose() {
		// SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
		// SystemChrome.setPreferredOrientations([
		// 	DeviceOrientation.portraitDown,
		// 	DeviceOrientation.portraitUp,
		// ]);
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final args = ModalRoute.of(context)!.settings.arguments as PlayerRouteParameters;
		return GenericRoute(
			hideExitFab: true,
			// onExitTap: (context) async {
			// 	final current = DateTime.now().millisecondsSinceEpoch;
			// 	if (current - ref.read(webviewPopTimeProvider) > kWebviewPopDelay) {
			// 		ref.read(webviewPopTimeProvider.notifier).update((state) => current);
			// 		Fluttertoast.showToast(
			// 			msg: context.tr.playerConfirmExit,
			// 			toastLength: Toast.LENGTH_SHORT,
			// 			gravity: ToastGravity.BOTTOM,
			// 			backgroundColor: Theme.of(context).colorScheme.background,
			// 			textColor: Theme.of(context).textTheme.bodyMedium?.color,
			// 		);
			// 		return false;
			// 	}
			// 	ref.read(webviewControllerProvider)?.evaluateJavascript(source: "document.exitFullscreen();");
			// 	await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
			// 	await SystemChrome.setPreferredOrientations([
			// 		DeviceOrientation.portraitDown,
			// 		DeviceOrientation.portraitUp,
			// 	]);
			// 	return true;
			// },
			body: Center(
				child: ref.watch(videoProvider(args.episode)).when(
					loading: () => const CircularProgressIndicator(),
					error: (err, stackTrace) => const LargeIcon(Boxicons.bxs_error_circle),
					data: (videoUrl) {
						if (videoUrl == null) {
							return const LargeIcon(Boxicons.bxs_error_circle);
						}
						switch (args.playerType) {
							case PlayerType.webview:
								return _WebviewPlayer(videoUrl);
							case PlayerType.native:
								return _NativePlayerProvider(videoUrl);
						}
					},
				),
			),
		);
	}
}


class _WebviewPlayer extends ConsumerWidget {

	final Uri videoUrl;

	const _WebviewPlayer(this.videoUrl);

	@override
	Widget build(BuildContext context, WidgetRef ref) => Stack(
		alignment: Alignment.center,
		children: [
			InAppWebView(
				key: GlobalKey(),
				initialUrlRequest: URLRequest(url: videoUrl),
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

class _NativePlayerProvider extends ConsumerWidget {

	final Uri videoUrl;

	const _NativePlayerProvider(this.videoUrl);

	@override
	Widget build(BuildContext context, WidgetRef ref) => ref.watch(
		hlsProvider(
			HlsProviderData(
				assetBundle: DefaultAssetBundle.of(context),
				videoUrl: videoUrl,
			),
		),
	).when(
		loading: () => const CircularProgressIndicator(),
		error: (err, stackTrace) => const LargeIcon(Boxicons.bxs_error_circle),
		data: (hlsStreams) {
			final theme = Theme.of(context);
			return BetterPlayer(
				controller: BetterPlayerController(
					BetterPlayerConfiguration(
						aspectRatio: 16 / 9,
						fullScreenAspectRatio: 16 / 9,
						allowedScreenSleep: false,
						autoPlay: true,
						fullScreenByDefault: true,
						errorBuilder: (context, err) => const LargeIcon(Boxicons.bxs_error_circle),
						controlsConfiguration: BetterPlayerControlsConfiguration(
							iconsColor: kOnImageColor,
							playIcon: Boxicons.bxs_right_arrow,
							pauseIcon: Boxicons.bx_pause,
							muteIcon: Boxicons.bx_volume_full,
							unMuteIcon: Boxicons.bx_volume_mute,
							pipMenuIcon: Boxicons.bx_error,
							skipBackIcon: Boxicons.bx_rewind,
							skipForwardIcon: Boxicons.bx_fast_forward,
							audioTracksIcon: Boxicons.bx_equalizer,
							qualitiesIcon: Boxicons.bxs_videos,
							subtitlesIcon: Boxicons.bx_captions,
							overflowMenuIcon: Boxicons.bx_dots_vertical_rounded,
							playbackSpeedIcon: Boxicons.bx_timer,
							fullscreenEnableIcon: Boxicons.bx_fullscreen,
							fullscreenDisableIcon: Boxicons.bx_exit_fullscreen,
							backgroundColor: theme.colorScheme.background,
							enableAudioTracks: false,
							enableSubtitles: false,
							loadingColor: theme.colorScheme.primary,
							overflowModalColor: theme.colorScheme.surface,
							overflowModalTextColor: theme.textTheme.bodyLarge!.color!,
							overflowMenuIconsColor: theme.iconTheme.color!,
							progressBarHandleColor: theme.colorScheme.primary,
							progressBarPlayedColor: theme.colorScheme.primary,
							
							// TODO: custom controls
							// playerTheme: BetterPlayerTheme.custom,
							// customControlsBuilder: (controller, a) => const Icon(
							// 	Boxicons.bx_alarm,
							// ),
							
							// TODO: history & watched tracking items
							// overflowMenuCustomItems: 
						),
						translations: [
							...AppLocalizations.supportedLocales.map((locale) {
								final tr = lookupAppLocalizations(locale);
								return BetterPlayerTranslations(
									languageCode: locale.languageCode,
									controlsLive: tr.playerControlsLive,
									controlsNextVideoIn: tr.playerControlsNextVideoIn,
									generalDefault: tr.playerGeneralDefault,
									generalDefaultError: tr.playerGeneralDefaultError,
									generalNone: tr.playerGeneralNone,
									generalRetry: tr.playerGeneralRetry,
									overflowMenuAudioTracks: tr.playerOverflowMenuAudioTracks,
									overflowMenuPlaybackSpeed: tr.playerOverflowMenuPlaybackSpeed,
									overflowMenuQuality: tr.playerOverflowMenuQuality,
									overflowMenuSubtitles: tr.playerOverflowMenuSubtitles,
									playlistLoadingNextVideo: tr.playerPlaylistLoadingNextVideo,
									qualityAuto: tr.playerQualityAuto,
								);
							}),
						],
					),
					betterPlayerDataSource: BetterPlayerDataSource.memory(
						hlsStreams.values.last,
						videoExtension: "m3u8",
						useAsmsSubtitles: false,
						qualities: hlsStreams.map(
							(key, value) => MapEntry(key, utf8.decode(value)),
						),
					),
				),
			);
		},
	);
}
