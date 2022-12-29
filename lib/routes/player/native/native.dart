
import 'dart:io';

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/models/hls_prov_data.dart';
import 'package:nekodroid/models/player_route_params.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/player/native/providers/hls.dart';
import 'package:nekodroid/routes/player/native/providers/player_controls.dart';
import 'package:nekodroid/routes/player/native/providers/player_is_init.dart';
import 'package:nekodroid/routes/player/providers/player_value.dart';
import 'package:nekodroid/routes/player/native/widgets/player_controls.dart';
import 'package:nekodroid/routes/player/native/widgets/player_controls_quick_skip_overlay.dart';
import 'package:nekodroid/schemas/isar_episode_status.dart';
import 'package:nekodroid/widgets/labelled_icon.dart';
import 'package:nekodroid/widgets/large_icon.dart';
import 'package:video_player/video_player.dart';


class NativePlayer extends ConsumerWidget {

  final PlayerRouteParams playerRouteParameters;
  final Uri videoUrl;
  final void Function(BuildContext context) onExit;
  final void Function()? onPrevious;
  final void Function()? onNext;

  const NativePlayer({
    required this.playerRouteParameters,
    required this.videoUrl,
    required this.onExit,
    this.onPrevious,
    this.onNext,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref.watch(
    hlsProv(HlsProvData(videoUrl: videoUrl, assetBundle: DefaultAssetBundle.of(context))),
  ).when(
    loading: () => const CircularProgressIndicator(),
    error: (err, stackTrace) => LabelledIcon.vertical(
      icon: const LargeIcon(Boxicons.bxs_error_circle),
      label: err.toString().split(":").last.trim(),
    ),
    data: (hlsStreams) => _VideoPlayer(
      playerRouteParameters: playerRouteParameters,
      hlsStreams: hlsStreams,
      onExit: onExit,
      onPrevious: onPrevious,
      onNext: onNext,
    ),
  );
}


class _VideoPlayer extends ConsumerStatefulWidget {
  
  final PlayerRouteParams playerRouteParameters;
  final Map<String, File> hlsStreams;
  final void Function(BuildContext context) onExit;
  final void Function()? onPrevious;
  final void Function()? onNext;

  const _VideoPlayer({
    required this.playerRouteParameters,
    required this.hlsStreams,
    required this.onExit,
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
    _controllerInit(
      widget.hlsStreams.values.first,
      _getStartTime(),
    );
    super.initState();
  }

  @override
  void dispose() {
    for (final file in widget.hlsStreams.values) {
      file.deleteSync(recursive: true);
    }
    _controllerDispose();
    super.dispose();
  }

  Duration? _getStartTime() {
    if (!ref.read(settingsProv).player.epContinueAtLastLocation) {
      return null;
    }
    return Isar.getInstance()?.isarEpisodeStatus.getByUrlSync(
      widget.playerRouteParameters.episode.url.toString(),
    )?.lastPositionDuration;
  }

  void _controllerInit(File file, [Duration? startAt]) =>
    controller = VideoPlayerController.file(file)
      ..addListener(_controllerListener)
      ..initialize().then((_) {
        ref.read(playerIsInitProv.notifier).update((_) => true);
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
    ref.read(playerValueProv.notifier).update((_) => controller.value);
    ref.read(playerControlsProv.notifier).isPlaying = controller.value.isPlaying;
    if (controller.value.position >= controller.value.duration) {
      ref.read(playerControlsProv.notifier).videoDone();
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    alignment: Alignment.center,
    children: [
      VideoPlayer(controller),
      if (ref.watch(playerIsInitProv))
        ...[
          PlayerControls(
            controller: controller,
            qualities: widget.hlsStreams,
            title: widget.playerRouteParameters.anime?.title ?? "",
            subtitle: context.tr.episodeLong(widget.playerRouteParameters.episode.episodeNumber),
            changeVideo: (newVid) => _controllerInit(newVid, _controllerDispose()),
            onExit: widget.onExit,
            onPrevious: widget.onPrevious,
            onNext: widget.onNext,
          ),
          const PlayerControlsQuickSkipOverlay(),
          if (
            ref.watch(playerValueProv.select((v) => v.isBuffering))
            && !ref.watch(playerControlsProv.select((v) => v.controlsDisplay))
          )
            const Center(child: CircularProgressIndicator()),
        ]
      else
        const Center(child: CircularProgressIndicator()),
    ],
  );
}
