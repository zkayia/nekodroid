
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/widgets/settings_sliver_title_route.dart';
import 'package:nekodroid/widgets/slider_setting.dart';
import 'package:nekodroid/widgets/switch_setting.dart';


class SettingsPlayerRoute extends ConsumerWidget {

  const SettingsPlayerRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SettingsSliverTitleRoute(
    title: context.tr.player,
    children: [
      SwitchSetting(
        title: context.tr.confirmExit,
        subtitle: context.tr.confirmExitDesc,
        value: ref.watch(settingsProv.select((v) => v.player.confirmOnBackExit)),
        onChanged: (v) => ref.read(settingsProv.notifier).confirmOnBackExit = v,
      ),
      SliderSetting(
        title: context.tr.confirmExitDuration,
        subtitle: context.tr.confirmExitDurationDesc,
        label: ref.watch(settingsProv.select((v) => v.player.backExitDuration)).toString(),
        enabled: ref.watch(settingsProv.select((v) => v.player.confirmOnBackExit)),
        value: ref.watch(settingsProv.select((v) => v.player.backExitDuration)),
        min: 1,
        max: 30,
        steps: 1,
        onChanged: (v) => ref.read(settingsProv.notifier).backExitDelay = v.toInt(),
      ),
      SwitchSetting(
        title: context.tr.rememberLastLocation,
        subtitle: context.tr.rememberLastLocationDesc,
        value: ref.watch(settingsProv.select((v) => v.player.epContinueAtLastLocation)),
        onChanged: (v) => ref.read(settingsProv.notifier).epContinueAtLastLocation = v,
      ),
      SwitchSetting(
        title: context.tr.autoMarkCompleted,
        subtitle: context.tr.autoMarkCompletedDesc,
        value: ref.watch(settingsProv.select((v) => v.player.epAutoMarkCompleted)),
        onChanged: (v) => ref.read(settingsProv.notifier).epAutoMarkCompleted = v,
      ),
      SliderSetting(
        title: context.tr.autoMarkCompletedThreshold,
        subtitle: context.tr.autoMarkCompletedThresholdDesc,
        label: ref.watch(
          settingsProv.select((v) => v.player.epAutoMarkCompletedThreshold),
        ).toString(),
        enabled: ref.watch(settingsProv.select((v) => v.player.epAutoMarkCompleted)),
        value: ref.watch(
          settingsProv.select((v) => v.player.epAutoMarkCompletedThreshold),
        ),
        min: 0,
        max: 100,
        steps: 1,
        onChanged: (v) =>
          ref.read(settingsProv.notifier).epAutoMarkCompletedThreshold = v.toInt(),
      ),
      SliderSetting(
        title: context.tr.controlsDisplayDuration,
        subtitle: context.tr.controlsDisplayDurationDesc,
        label: ref.watch(
          settingsProv.select((v) => v.player.controlsDisplayDuration),
        ).toString(),
        value: ref.watch(settingsProv.select((v) => v.player.controlsDisplayDuration)),
        min: 1,
        max: 30,
        steps: 1,
        onChanged: (v) =>
          ref.read(settingsProv.notifier).controlsDisplayDuration = v.toInt(),
      ),
      SliderSetting(
        title: context.tr.controlsBackgroundTransparency,
        subtitle: context.tr.controlsBackgroundTransparencyDesc,
        label: ref.watch(
          settingsProv.select((v) => v.player.controlsBackgroundTransparency),
        ).toString(),
        value: ref.watch(
          settingsProv.select((v) => v.player.controlsBackgroundTransparency),
        ),
        min: 0,
        max: 100,
        steps: 1,
        onChanged: (v) =>
          ref.read(settingsProv.notifier).controlsBackgroundTransparency = v.toInt(),
      ),
      SwitchSetting(
        title: context.tr.pauseOnControlsDisplay,
        subtitle: context.tr.pauseOnControlsDisplayDesc,
        value: ref.watch(settingsProv.select((v) => v.player.controlsPauseOnDisplay)),
        onChanged: (v) => ref.read(settingsProv.notifier).controlsPauseOnDisplay = v,
      ),
      SliderSetting(
        title: context.tr.introSkipTime,
        subtitle: context.tr.introSkipTimeDesc,
        label: ref.watch(settingsProv.select((v) => v.player.introSkipTime)).toString(),
        value: ref.watch(settingsProv.select((v) => v.player.introSkipTime)),
        min: 0,
        max: 500,
        steps: 1,
        onChanged: (v) => ref.read(settingsProv.notifier).introSkipTime = v.toInt(),
      ),
      SliderSetting(
        title: context.tr.forwardQuickSkipTime,
        subtitle: context.tr.forwardQuickSkipTimeDesc,
        label: ref.watch(
          settingsProv.select((v) => v.player.quickSkipForwardTime),
        ).toString(),
        value: ref.watch(settingsProv.select((v) => v.player.quickSkipForwardTime)),
        min: 0,
        max: 30,
        steps: 1,
        onChanged: (v) =>
          ref.read(settingsProv.notifier).quickSkipForwardTime = v.toInt(),
      ),
      SliderSetting(
        title: context.tr.backwardQuickSkipTime,
        subtitle: context.tr.backwardQuickSkipTimeDesc,
        label: ref.watch(
          settingsProv.select((v) => v.player.quickSkipBackwardTime),
        ).toString(),
        value: ref.watch(settingsProv.select((v) => v.player.quickSkipBackwardTime)),
        min: 0,
        max: 30,
        steps: 1,
        onChanged: (v) =>
          ref.read(settingsProv.notifier).quickSkipBackwardTime = v.toInt(),
      ),
      SliderSetting(
        title: context.tr.quickSkipDisplayDuration,
        subtitle: context.tr.quickSkipDisplayDurationDesc,
        label: ref.watch(
          settingsProv.select((v) => v.player.quickSkipDisplayDuration),
        ).toString(),
        value: ref.watch(settingsProv.select((v) => v.player.quickSkipDisplayDuration)),
        min: 0,
        max: 1000,
        steps: 50,
        onChanged: (v) =>
          ref.read(settingsProv.notifier).quickSkipDisplayDuration = v.toInt(),
      ),
    ],
  );
}
