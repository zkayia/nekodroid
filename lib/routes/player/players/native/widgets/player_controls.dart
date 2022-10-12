
import 'dart:io';

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/player/players/native/providers/player_controls.dart';
import 'package:nekodroid/routes/player/players/native/widgets/progress_bar.dart';
import 'package:nekodroid/widgets/generic_form_dialog.dart';
import 'package:nekodroid/widgets/single_line_text.dart';
import 'package:video_player/video_player.dart';


/* CONSTANTS */




/* MODELS */




/* PROVIDERS */




/* MISC */




/* WIDGETS */

class PlayerControls extends ConsumerWidget {

  final VideoPlayerController controller;
  final ProviderBase<VideoPlayerValue> playerValProvider;
  final Map<String, File> qualities;
  final String title;
  final String subtitle;
  final void Function(File newVid) changeVideo;
  final void Function()? onPrevious;
  final void Function()? onNext;

  const PlayerControls({
    required this.controller,
    required this.playerValProvider,
    required this.qualities,
    required this.title,
    required this.subtitle,
    required this.changeVideo,
    this.onPrevious,
    this.onNext,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Positioned.fill(
    child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTap: () {
        final action = ref.read(playerControlsProvider).dtCurrent;
        if (action != null) {
          controller.seekTo(
            ref.read(playerValProvider).position + Duration(
              seconds: action == DoubleTapAction.rewind
                ? -ref.read(settingsProvider).player.quickSkipBackwardTime
                : ref.read(settingsProvider).player.quickSkipForwardTime,
            ),
          );
          ref.read(playerControlsProvider.notifier)
            ..dtUpdate(action)
            ..didAction();
        }
      },
      onDoubleTapDown: (tapDetails) {
        final screenSize = MediaQuery.of(context).size;
        final tapPos = tapDetails.globalPosition;
        if (
          ref.read(playerControlsProvider).controlsDisplay
          && (tapPos.dy < screenSize.height * 0.2 || screenSize.height * 0.8 < tapPos.dy)
        ) {
          ref.read(playerControlsProvider.notifier).dtCurrent = null;
          return;
        }
        final zoneWidth = screenSize.width * 0.3;
        ref.read(playerControlsProvider.notifier).dtCurrent = tapPos.dx < zoneWidth
          ? DoubleTapAction.rewind
          : screenSize.width - zoneWidth < tapPos.dx
            ? DoubleTapAction.fastForward
            : null;
      },
      onTap: () {
        if (
          ref.read(playerValProvider).isPlaying
          && !ref.read(playerControlsProvider).controlsDisplay
          && ref.read(settingsProvider).player.controlsPauseOnDisplay
        ) {
          controller.pause();
        }
        ref.watch(playerControlsProvider.notifier)
          ..toggleControls()
          ..didAction();
      },
      child: IgnorePointer(
        ignoring: !ref.watch(playerControlsProvider).controlsDisplay,
        child: AnimatedOpacity(
          opacity: ref.watch(playerControlsProvider).controlsDisplay ? 1 : 0,
          duration: kDefaultAnimDuration,
          curve: kDefaultAnimCurve,
          child: _PlayerControlsMainUi(
            controller: controller,
            playerValProvider: playerValProvider,
            qualities: qualities,
            title: title,
            subtitle: subtitle,
            changeVideo: changeVideo,
            onPrevious: onPrevious,
            onNext: onNext,
          ),
        ),
      ),
    ),
  );
}


class PlayerControlsQuickSkipOverlay extends ConsumerWidget {
  
  const PlayerControlsQuickSkipOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(playerControlsProvider.select((value) => value.dtDisplay));
    return display == null
      ? const SizedBox.shrink()
      : Align(
        alignment: display == DoubleTapAction.rewind
          ? Alignment.centerLeft
          : Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints.tight(
            Size.fromWidth(MediaQuery.of(context).size.width * 0.3),
          ),
          child: Center(
            child: Icon(
              display == DoubleTapAction.rewind
                ? Boxicons.bx_rewind
                : Boxicons.bx_fast_forward,
            ),
          ),
        ),
      );
  }
}


class _PlayerControlsMainUi extends ConsumerWidget {
  
  final VideoPlayerController controller;
  final ProviderBase<VideoPlayerValue> playerValProvider;
  final Map<String, File> qualities;
  final String title;
  final String subtitle;
  final void Function(File newVid) changeVideo;
  final void Function()? onPrevious;
  final void Function()? onNext;

  const _PlayerControlsMainUi({
    required this.controller,
    required this.playerValProvider,
    required this.qualities,
    required this.title,
    required this.subtitle,
    required this.changeVideo,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth10 = MediaQuery.of(context).size.width * 0.1;
    return Material(
      color: Colors.black.withAlpha(
        255 * ref.read(settingsProvider).player.controlsBackgroundTransparency ~/ 100,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Boxicons.bx_x),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleLineText(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SingleLineText.secondary(
                      subtitle,
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth10),
              IconButton(
                onPressed: () async {
                  ref.read(playerControlsProvider.notifier).inAction = true;
                  final newSpeed = await showDialog<double>(
                    context: context,
                    builder: (context) => GenericFormDialog.radio(
                      title: context.tr.playerPlaybackSpeed,
                      elements: [
                        for (final speed in [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0])
                          GenericFormDialogElement(
                            label: speed.toString(),
                            value: speed,
                            selected: speed == ref.read(playerValProvider).playbackSpeed,
                          ),
                      ],
                    ),
                  );
                  if (newSpeed != null) {
                    controller.setPlaybackSpeed(newSpeed);
                  }
                  ref.read(playerControlsProvider.notifier)
                    ..didAction()
                    ..inAction = false;
                },
                icon: const Icon(Boxicons.bx_timer),
              ),
              IconButton(
                onPressed: qualities.isEmpty
                  ? null
                  : () async {
                    ref.read(playerControlsProvider.notifier).inAction = true;
                    final newQuality = await showDialog<File>(
                      context: context,
                      builder: (context) => GenericFormDialog.radio(
                        title: context.tr.playerQuality,
                        elements: [
                          for (final quality in qualities.entries)
                            GenericFormDialogElement(
                              label: quality.key,
                              value: quality.value,
                              selected: "file://${quality.value.path}" == controller.dataSource,
                            ),
                        ],
                      ),
                    );
                    if (newQuality != null) {
                      changeVideo(newQuality);
                    }
                    ref.read(playerControlsProvider.notifier)
                      ..didAction()
                      ..inAction = false;
                  },
                icon: const Icon(Boxicons.bxs_videos),
              ),
              IconButton(
                onPressed: () {
                  controller.setVolume((ref.read(playerValProvider).volume + 1) % 2);
                  ref.watch(playerControlsProvider.notifier).didAction();
                },
                icon: Icon(
                  ref.watch(playerValProvider.select((value) => value.volume)) == 0
                    ? Boxicons.bx_volume_mute
                    : Boxicons.bx_volume_full,
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.seekTo(
                    controller.value.position + Duration(
                      seconds: ref.read(settingsProvider).player.introSkipTime,
                    ),
                  );
                  ref.watch(playerControlsProvider.notifier).didAction();
                },
                icon: const Icon(Boxicons.bx_fast_forward),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onPrevious != null
                  ? () {
                    ref.watch(playerControlsProvider.notifier).didAction();
                    onPrevious!();
                  }
                  : null,
                icon: const Icon(Boxicons.bx_skip_previous),
              ),
              SizedBox(width: screenWidth10),
              ConstrainedBox(
                constraints: BoxConstraints.tight(const Size.square(kLargeIconSize)),
                child: ref.watch(playerValProvider.select((value) => value.isBuffering))
                  ? const CircularProgressIndicator()
                  : IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (ref.read(playerValProvider).isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
                      }
                      ref.watch(playerControlsProvider.notifier).didAction();
                    },
                    iconSize: kLargeIconSize,
                    icon: ref.watch(playerValProvider.select((value) => value.isPlaying))
                      ? const Icon(Boxicons.bx_pause)
                      : 
                        ref.watch(playerValProvider.select((value) => value.position))
                        >= ref.watch(playerValProvider.select((value) => value.duration))
                          ? Transform.scale(
                            scaleX: -1,
                            child: const Icon(Boxicons.bx_revision),
                          )
                          : const Icon(Boxicons.bx_play),
                  ),
              ),
              SizedBox(width: screenWidth10),
              IconButton(
                onPressed: onNext != null
                  ? () {
                      ref.watch(playerControlsProvider.notifier).didAction();
                      onNext!();
                    }
                  : null,
                icon: const Icon(Boxicons.bx_skip_next),
              ),
            ],
          ),
          ProgressBar(
            position: ref.watch(playerValProvider.select((value) => value.position)),
            duration: ref.watch(playerValProvider.select((value) => value.duration)),
            onSeek: (newPos) {
              controller.seekTo(newPos);
              ref.watch(playerControlsProvider.notifier).didAction();
            },
          ),
        ],
      ),
    );
  }
}
