
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants/double_tap_action.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/player/native/providers/player_controls.dart';
import 'package:nekodroid/routes/player/providers/player_value.dart';
import 'package:nekodroid/routes/player/native/widgets/player_controls_main_ui.dart';
import 'package:video_player/video_player.dart';


class PlayerControls extends ConsumerWidget {

  final VideoPlayerController controller;
  final Map<String, File> qualities;
  final String title;
  final String subtitle;
  final void Function(File newVid) changeVideo;
  final void Function(BuildContext context) onExit;
  final void Function()? onPrevious;
  final void Function()? onNext;

  const PlayerControls({
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
  Widget build(BuildContext context, WidgetRef ref) => Positioned.fill(
    child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTap: () {
        final action = ref.read(playerControlsProv).dtCurrent;
        if (action != null) {
          controller.seekTo(
            ref.read(playerValueProv).position + Duration(
              seconds: action == DoubleTapAction.rewind
                ? -ref.read(settingsProv).player.quickSkipBackwardTime
                : ref.read(settingsProv).player.quickSkipForwardTime,
            ),
          );
          ref.read(playerControlsProv.notifier)
            ..dtUpdate(action)
            ..didAction();
        }
      },
      onDoubleTapDown: (tapDetails) {
        final screenSize = MediaQuery.of(context).size;
        final tapPos = tapDetails.globalPosition;
        if (
          ref.read(playerControlsProv).controlsDisplay
          && (tapPos.dy < screenSize.height * 0.2 || screenSize.height * 0.8 < tapPos.dy)
        ) {
          ref.read(playerControlsProv.notifier).dtCurrent = null;
          return;
        }
        final zoneWidth = screenSize.width * 0.3;
        ref.read(playerControlsProv.notifier).dtCurrent = tapPos.dx < zoneWidth
          ? DoubleTapAction.rewind
          : screenSize.width - zoneWidth < tapPos.dx
            ? DoubleTapAction.fastForward
            : null;
      },
      onTap: () {
        if (
          ref.read(playerValueProv).isPlaying
          && !ref.read(playerControlsProv).controlsDisplay
          && ref.read(settingsProv).player.controlsPauseOnDisplay
        ) {
          controller.pause();
        }
        ref.watch(playerControlsProv.notifier)
          ..toggleControls()
          ..didAction();
      },
      child: IgnorePointer(
        ignoring: !ref.watch(playerControlsProv).controlsDisplay,
        child: Opacity(
          opacity: ref.watch(playerControlsProv).controlsDisplay ? 1 : 0,
          child: PlayerControlsMainUi(
            controller: controller,
            qualities: qualities,
            title: title,
            subtitle: subtitle,
            changeVideo: changeVideo,
            onExit: onExit,
            onPrevious: onPrevious,
            onNext: onNext,
          ),
        ),
      ),
    ),
  );
}
