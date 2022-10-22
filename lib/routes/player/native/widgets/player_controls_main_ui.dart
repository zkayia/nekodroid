
import 'dart:io';

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/models/generic_form_dialog_element.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/player/native/providers/player_controls.dart';
import 'package:nekodroid/routes/player/providers/player_value.dart';
import 'package:nekodroid/routes/player/native/widgets/progress_bar.dart';
import 'package:nekodroid/widgets/generic_form_dialog.dart';
import 'package:nekodroid/widgets/single_line_text.dart';
import 'package:video_player/video_player.dart';


class PlayerControlsMainUi extends ConsumerWidget {
  
  final VideoPlayerController controller;
  final Map<String, File> qualities;
  final String title;
  final String subtitle;
  final void Function(File newVid) changeVideo;
  final void Function(BuildContext context) onExit;
  final void Function()? onPrevious;
  final void Function()? onNext;

  const PlayerControlsMainUi({
    required this.controller,
    required this.qualities,
    required this.title,
    required this.subtitle,
    required this.changeVideo,
    required this.onExit,
    this.onPrevious,
    this.onNext,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth10 = MediaQuery.of(context).size.width * 0.1;
    return Material(
      color: Colors.black.withAlpha(
        255 * ref.read(settingsProv).player.controlsBackgroundTransparency ~/ 100,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => onExit(context),
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
                  ref.read(playerControlsProv.notifier).inAction = true;
                  final newSpeed = await showDialog<double>(
                    context: context,
                    builder: (context) => GenericFormDialog.radio(
                      title: context.tr.playerPlaybackSpeed,
                      elements: [
                        for (final speed in [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0])
                          GenericFormDialogElement(
                            label: speed.toString(),
                            value: speed,
                            selected: speed == ref.read(playerValueProv).playbackSpeed,
                          ),
                      ],
                    ),
                  );
                  if (newSpeed != null) {
                    controller.setPlaybackSpeed(newSpeed);
                  }
                  ref.read(playerControlsProv.notifier)
                    ..didAction()
                    ..inAction = false;
                },
                icon: const Icon(Boxicons.bx_timer),
              ),
              IconButton(
                onPressed: qualities.isEmpty
                  ? null
                  : () async {
                    ref.read(playerControlsProv.notifier).inAction = true;
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
                    ref.read(playerControlsProv.notifier)
                      ..didAction()
                      ..inAction = false;
                  },
                icon: const Icon(Boxicons.bxs_videos),
              ),
              IconButton(
                onPressed: () {
                  controller.setVolume((ref.read(playerValueProv).volume + 1) % 2);
                  ref.watch(playerControlsProv.notifier).didAction();
                },
                icon: Icon(
                  ref.watch(playerValueProv.select((v) => v.volume)) == 0
                    ? Boxicons.bx_volume_mute
                    : Boxicons.bx_volume_full,
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.seekTo(
                    controller.value.position + Duration(
                      seconds: ref.read(settingsProv).player.introSkipTime,
                    ),
                  );
                  ref.watch(playerControlsProv.notifier).didAction();
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
                    ref.watch(playerControlsProv.notifier).didAction();
                    onPrevious!();
                  }
                  : null,
                icon: const Icon(Boxicons.bx_skip_previous),
              ),
              SizedBox(width: screenWidth10),
              ConstrainedBox(
                constraints: BoxConstraints.tight(const Size.square(kLargeIconSize)),
                child: ref.watch(playerValueProv.select((v) => v.isBuffering))
                  ? const CircularProgressIndicator()
                  : IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (ref.read(playerValueProv).isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
                      }
                      ref.watch(playerControlsProv.notifier).didAction();
                    },
                    iconSize: kLargeIconSize,
                    icon: ref.watch(playerValueProv.select((v) => v.isPlaying))
                      ? const Icon(Boxicons.bx_pause)
                      : 
                        ref.watch(playerValueProv.select((v) => v.position))
                        >= ref.watch(playerValueProv.select((v) => v.duration))
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
                      ref.watch(playerControlsProv.notifier).didAction();
                      onNext!();
                    }
                  : null,
                icon: const Icon(Boxicons.bx_skip_next),
              ),
            ],
          ),
          ProgressBar(
            position: ref.watch(playerValueProv.select((v) => v.position)),
            duration: ref.watch(playerValueProv.select((v) => v.duration)),
            onSeek: (newPos) {
              controller.seekTo(newPos);
              ref.watch(playerControlsProv.notifier).didAction();
            },
          ),
        ],
      ),
    );
  }
}
