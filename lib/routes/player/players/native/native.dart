
import 'dart:io';

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/extensions/app_localizations.dart';
import 'package:nekodroid/routes/player/player.dart';
import 'package:nekodroid/routes/player/players/native/providers/hls.dart';
import 'package:nekodroid/routes/player/players/native/providers/player_controls.dart';
import 'package:nekodroid/routes/player/players/native/widgets/player_controls.dart';
import 'package:nekodroid/widgets/labelled_icon.dart';
import 'package:nekodroid/widgets/large_icon.dart';
import 'package:video_player/video_player.dart';


/* CONSTANTS */




/* MODELS */




/* PROVIDERS */

final _playerIsInitProvider = StateProvider.autoDispose<bool>(
	(ref) => false,
);

final _playerValProvider = StateProvider.autoDispose<VideoPlayerValue>(
	(ref) => VideoPlayerValue(duration: Duration.zero),
);


/* MISC */




/* WIDGETS */

class NativePlayer extends ConsumerWidget {

	final PlayerRouteParameters playerRouteParameters;
	final Uri videoUrl;
	final void Function()? onPrevious;
	final void Function()? onNext;

	const NativePlayer({
		super.key,
		required this.playerRouteParameters,
		required this.videoUrl,
		this.onPrevious,
		this.onNext,
	});

	@override
	Widget build(BuildContext context, WidgetRef ref) => ref.watch(
		hlsProvider(HlsProviderData(videoUrl: videoUrl, assetBundle: DefaultAssetBundle.of(context))),
	).when(
		loading: () => const CircularProgressIndicator(),
		error: (err, stackTrace) => LabelledIcon.vertical(
			icon: const LargeIcon(Boxicons.bxs_error_circle),
			label: err.toString().split(":").last.trim(),
		),
		data: (hlsStreams) => _VideoPlayer(
			playerRouteParameters: playerRouteParameters,
			hlsStreams: hlsStreams,
			onPrevious: onPrevious,
			onNext: onNext,
		),
	);
}


class _VideoPlayer extends ConsumerStatefulWidget {
	
	final PlayerRouteParameters playerRouteParameters;
	final Map<String, File> hlsStreams;
	final void Function()? onPrevious;
	final void Function()? onNext;

	const _VideoPlayer({
		required this.playerRouteParameters,
		required this.hlsStreams,
		this.onPrevious,
		this.onNext,
	});

	@override
	_VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends ConsumerState<_VideoPlayer> {
	
	late VideoPlayerController controller;

	@override
	void initState() {
		_controllerInit(widget.hlsStreams.values.first);
		super.initState();
	}

	@override
	void dispose() {
		for (final file in widget.hlsStreams.values) {
			file.deleteSync();
		}
		// TODO: save exit time
		_controllerDispose();
		super.dispose();
	}

	void _controllerInit(File file, [Duration? startAt]) =>
		controller = VideoPlayerController.file(file)
			..addListener(_controllerListener)
			..initialize().then((_) {
				ref.read(_playerIsInitProvider.notifier).update((_) => true);
				controller
					..seekTo(startAt ?? Duration.zero)
					..play();
			});

	Duration _controllerDispose() {
		controller
			..removeListener(_controllerListener)
			..dispose();
		return controller.value.position;
	}

	void _controllerListener() {
		ref.read(_playerValProvider.notifier).update((_) => controller.value);
		ref.read(playerControlsProvider.notifier).isPlaying = controller.value.isPlaying;
		if (controller.value.position >= controller.value.duration) {
			ref.read(playerControlsProvider.notifier).videoDone();
		}
	}

	@override
	Widget build(BuildContext context) {
		// To keep the state when disabling visibility
		// when riverpod ^2.0.0 comes
		// remove thoses and autoDispose then ref.invalidate it in dispose
		ref.watch(_playerValProvider);
		return Stack(
			fit: StackFit.expand,
			alignment: Alignment.center,
			children: [
				VideoPlayer(controller),
				if (ref.watch(_playerIsInitProvider))
					...[
						PlayerControls(
							controller: controller,
							playerValProvider: _playerValProvider,
							qualities: widget.hlsStreams,
							title: widget.playerRouteParameters.anime?.title ?? "",
							subtitle: context.tr.episodeLong(widget.playerRouteParameters.episode.episodeNumber),
							changeVideo: (newVid) => _controllerInit(newVid, _controllerDispose()),
							onPrevious: widget.onPrevious,
							onNext: widget.onNext,
						),
						const PlayerControlsQuickSkipOverlay(),
					]
				else
					const Center(child: CircularProgressIndicator()),
			],
		);
	}
}
