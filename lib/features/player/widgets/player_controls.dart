import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/features/player/data/player_quality.dart';
import 'package:nekodroid/features/player/logic/player_value.dart';
import 'package:nekodroid/features/player/logic/show_controls.dart';
import 'package:nekodroid/features/player/logic/webview_channel_port.dart';
import 'package:nekodroid/features/player/widgets/progress_bar.dart';
import 'package:nekodroid/features/player/data/player_settings.dart';

class PlayerControls extends ConsumerWidget {
  final String title;
  final String subtitle;
  final void Function(BuildContext context) onExit;
  final void Function()? onPrevious;
  final void Function()? onNext;

  const PlayerControls({
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
      color: Colors.black.withOpacity(const PlayerSettings().controlsBackgroundTransparency * 0.01),
      child: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: IconTheme(
          data: theme.iconTheme.copyWith(color: kNativePlayerControlsColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => onExit(context),
                    icon: const Icon(Symbols.close_rounded),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: hasSubtitle ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.bodyLarge?.copyWith(color: kNativePlayerControlsColor),
                          maxLines: 1,
                        ),
                        if (hasSubtitle)
                          Text(
                            subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(color: kNativePlayerControlsColor),
                            maxLines: 1,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth10),
                  MenuAnchor(
                    alignmentOffset: const Offset(-kPadding * 10, 0),
                    menuChildren: [
                      for (final speed in [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0])
                        MenuItemButton(
                          onPressed: () => ref.read(webviewChannelPortProvider.notifier).setPlaybackSpeed(speed),
                          trailingIcon: ref.watch(
                            playerValueProvider
                                .select((v) => speed == v?.playbackRate ? const Icon(Symbols.check_rounded) : null),
                          ),
                          child: Text("x$speed"),
                        ),
                    ],
                    onOpen: () => ref.read(showControlsProvider.notifier).setActionState("set_video_speed", true),
                    onClose: () {
                      ref.read(showControlsProvider.notifier)
                        ..didAction()
                        ..setActionState("set_video_speed", false);
                    },
                    builder: (context, controller, child) => IconButton(
                      onPressed: () => controller.isOpen ? controller.close() : controller.open(),
                      icon: child ?? const SizedBox(),
                    ),
                    child: const Icon(Symbols.slow_motion_video_rounded),
                  ),
                  MenuAnchor(
                    alignmentOffset: const Offset(-kPadding * 10, 0),
                    menuChildren: [
                      for (final PlayerQuality quality in ref.read(playerValueProvider.select((v) => v?.qualities ?? [])))
                        MenuItemButton(
                          onPressed: () => ref.read(webviewChannelPortProvider.notifier).setQuality(quality.index),
                          trailingIcon: ref.watch(
                            playerValueProvider
                                .select((v) => quality.index == v?.currentQuality ? const Icon(Symbols.check_rounded) : null),
                          ),
                          child: Text(quality.label),
                        ),
                    ],
                    onOpen: () => ref.read(showControlsProvider.notifier).setActionState("set_video_quality", true),
                    onClose: () {
                      ref.read(showControlsProvider.notifier)
                        ..didAction()
                        ..setActionState("set_video_quality", false);
                    },
                    builder: (context, controller, child) => IconButton(
                      onPressed: ref.watch(
                        playerValueProvider.select((v) => (v?.qualities.isEmpty ?? true) || v?.currentQuality == null),
                      )
                          ? null
                          : () => controller.isOpen ? controller.close() : controller.open(),
                      icon: child ?? const SizedBox(),
                    ),
                    child: const Icon(Symbols.video_settings_rounded),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(webviewChannelPortProvider.notifier).muteUnmute();
                      ref.watch(showControlsProvider.notifier).didAction();
                    },
                    icon: Icon(
                      ref.watch(playerValueProvider.select((v) => v?.muted ?? false))
                          ? Symbols.volume_off_rounded
                          : Symbols.volume_up_rounded,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(webviewChannelPortProvider.notifier).moveBy(const PlayerSettings().introSkipTime);
                      ref.watch(showControlsProvider.notifier).didAction();
                    },
                    icon: const Icon(Symbols.fast_forward_rounded),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (onPrevious != null || onNext != null)
                    IconButton(
                      onPressed: onPrevious != null
                          ? () {
                              ref.watch(showControlsProvider.notifier).didAction();
                              onPrevious!();
                            }
                          : null,
                      icon: const Icon(Symbols.skip_previous_rounded, fill: 1),
                    ),
                  SizedBox(width: screenWidth10),
                  ConstrainedBox(
                    constraints: BoxConstraints.tight(const Size.square(kLargeIconSize)),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        ref.read(webviewChannelPortProvider.notifier).playPause();
                        ref.watch(showControlsProvider.notifier).didAction();
                      },
                      iconSize: kLargeIconSize,
                      icon: ref.watch(playerValueProvider.select((v) => v?.paused ?? true))
                          ? ref.watch(playerValueProvider.select((v) => v?.ended ?? false))
                              ? const Icon(Symbols.replay_rounded)
                              : const Icon(Symbols.play_arrow_rounded, fill: 1)
                          : const Icon(Symbols.pause_rounded, fill: 1),
                    ),
                  ),
                  SizedBox(width: screenWidth10),
                  if (onPrevious != null || onNext != null)
                    IconButton(
                      onPressed: onNext != null
                          ? () {
                              ref.watch(showControlsProvider.notifier).didAction();
                              onNext!();
                            }
                          : null,
                      icon: const Icon(Symbols.skip_next_rounded, fill: 1),
                    ),
                ],
              ),
              ProgressBar(
                position: ref.watch(playerValueProvider.select((v) => v?.currentTime ?? Duration.zero)),
                duration: ref.watch(playerValueProvider.select((v) => v?.duration ?? Duration.zero)),
                bufferPosition:
                    ref.watch(playerValueProvider.select((v) => v?.buffered.reduce((m, e) => e.end > m.end ? e : m).end)),
                onSeekStart: () => ref.read(showControlsProvider.notifier).setActionState("progress_bar_seeking", true),
                onSeekEnd: (position) {
                  ref.read(webviewChannelPortProvider.notifier).goTo(position.inSeconds);
                  ref.watch(showControlsProvider.notifier)
                    ..didAction()
                    ..setActionState("progress_bar_seeking", false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
