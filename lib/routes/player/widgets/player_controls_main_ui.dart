
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/models/generic_form_dialog_element.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/player/providers/player_controls.dart';
import 'package:nekodroid/routes/player/providers/webview_channel_port.dart';
import 'package:nekodroid/routes/player/providers/player_value.dart';
import 'package:nekodroid/routes/player/widgets/progress_bar.dart';
import 'package:nekodroid/widgets/generic_form_dialog.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class PlayerControlsMainUi extends ConsumerWidget {
  
  final String title;
  final String subtitle;
  final void Function(BuildContext context) onExit;
  final void Function()? onPrevious;
  final void Function()? onNext;

  const PlayerControlsMainUi({
    required this.title,
    required this.subtitle,
    required this.onExit,
    this.onPrevious,
    this.onNext,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth10 = MediaQuery.of(context).size.width * 0.1;
    final hasSubtitle = subtitle.trim().isNotEmpty;
    return Material(
      color: Colors.black.withAlpha(
        255 * ref.read(settingsProv).player.controlsBackgroundTransparency ~/ 100,
      ),
      child: IconTheme(
        data: theme.iconTheme.copyWith(
          color: kNativePlayerControlsColor,
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
                    crossAxisAlignment: hasSubtitle
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                    children: [
                      SingleLineText(
                        title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: kNativePlayerControlsColor,
                        ),
                      ),
                      if (hasSubtitle)
                        SingleLineText(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: kNativePlayerControlsColor,
                          ),
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
                              selected: speed == ref.read(playerValueProv)?.playbackRate,
                            ),
                        ],
                      ),
                    );
                    if (newSpeed != null) {
                      ref.read(webviewChannelPortProv.notifier).setPlaybackSpeed(newSpeed);
                    }
                    ref.read(playerControlsProv.notifier)
                      ..didAction()
                      ..inAction = false;
                  },
                  icon: const Icon(Boxicons.bx_timer),
                ),
                IconButton(
                  onPressed: ref.watch(
                    playerValueProv.select(
                      (v) => (v?.qualities.isEmpty ?? true) || v?.currentQuality == null,
                    ),
                  )
                    ? null
                    : () async {
                      ref.read(playerControlsProv.notifier).inAction = true;
                      final newQuality = await showDialog<int>(
                        context: context,
                        builder: (context) => GenericFormDialog.radio(
                          title: context.tr.playerQuality,
                          elements: ref.read(playerValueProv.select((v) => v))?.qualities.map(
                            (e) => GenericFormDialogElement(
                              label: e.label,
                              value: e.index,
                              selected: ref.read(
                                playerValueProv.select((v) => v?.currentQuality == e.index),
                              ),
                            ),
                          ).toList() ?? const [],
                        ),
                      );
                      if (newQuality != null) {
                        ref.read(webviewChannelPortProv.notifier).setQuality(newQuality);
                      }
                      ref.read(playerControlsProv.notifier)
                        ..didAction()
                        ..inAction = false;
                    },
                  icon: const Icon(Boxicons.bxs_videos),
                ),
                IconButton(
                  onPressed: () {
                    ref.read(webviewChannelPortProv.notifier).muteUnmute();
                    ref.watch(playerControlsProv.notifier).didAction();
                  },
                  icon: Icon(
                    ref.watch(playerValueProv.select((v) => v?.muted ?? false))
                      ? Boxicons.bx_volume_mute
                      : Boxicons.bx_volume_full,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ref.read(webviewChannelPortProv.notifier).moveBy(
                      ref.read(settingsProv).player.introSkipTime,
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
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      ref.read(webviewChannelPortProv.notifier).playPause();
                      ref.watch(playerControlsProv.notifier).didAction();
                    },
                    iconSize: kLargeIconSize,
                    icon: ref.watch(playerValueProv.select((v) => v?.paused ?? true))
                      ? ref.watch(playerValueProv.select((v) => v?.ended ?? false))
                        ? Transform.scale(
                          scaleX: -1,
                          child: const Icon(Boxicons.bx_revision),
                        )
                        : const Icon(Boxicons.bx_play)
                      : const Icon(Boxicons.bx_pause),
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
              position: ref.watch(playerValueProv.select((v) => v?.currentTime ?? Duration.zero)),
              duration: ref.watch(playerValueProv.select((v) => v?.duration ?? Duration.zero)),
              onSeek: (newPos) {
                ref.read(webviewChannelPortProv.notifier).goTo(newPos.inSeconds);
                ref.watch(playerControlsProv.notifier).didAction();
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
