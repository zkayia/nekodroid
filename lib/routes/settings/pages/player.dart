
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants/widget_title_mixin.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/settings/widgets/settings_sliver_title_route.dart';
import 'package:nekodroid/routes/settings/widgets/slider_setting.dart';
import 'package:nekodroid/routes/settings/widgets/switch_setting.dart';


class SettingsPlayerPage extends ConsumerWidget implements WidgetTitleMixin {

  @override
  final String title;

  const SettingsPlayerPage(
    this.title,
    {
      super.key,
    }
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) => SettingsSliverTitleRoute(
    title: title,
    children: [
      SwitchSetting(
        title: context.tr.confirmExit,
        subtitle: context.tr.confirmExitDesc,
        value: ref.watch(settingsProvider.select((v) => v.player.confirmOnBackExit)),
        onChanged: (v) => ref.read(settingsProvider.notifier).confirmOnBackExit = v,
      ),
      SliderSetting(
        title: context.tr.confirmExitDuration,
        subtitle: context.tr.confirmExitDurationDesc,
        label: ref.watch(settingsProvider.select((v) => v.player.backExitDuration)).toString(),
        enabled: ref.watch(settingsProvider.select((v) => v.player.confirmOnBackExit)),
        value: ref.watch(settingsProvider.select((v) => v.player.backExitDuration)),
        min: 1,
        max: 30,
        steps: 1,
        onChanged: (v) => ref.read(settingsProvider.notifier).backExitDelay = v.toInt(),
      ),
      SwitchSetting(
        title: context.tr.rememberLastLocation,
        subtitle: context.tr.rememberLastLocationDesc,
        value: ref.watch(settingsProvider.select((v) => v.player.epContinueAtLastLocation)),
        onChanged: (v) => ref.read(settingsProvider.notifier).epContinueAtLastLocation = v,
      ),
      SwitchSetting(
        title: context.tr.autoMarkCompleted,
        subtitle: context.tr.autoMarkCompletedDesc,
        value: ref.watch(settingsProvider.select((v) => v.player.epAutoMarkCompleted)),
        onChanged: (v) => ref.read(settingsProvider.notifier).epAutoMarkCompleted = v,
      ),
      SliderSetting(
        title: context.tr.autoMarkCompletedThreshold,
        subtitle: context.tr.autoMarkCompletedThresholdDesc,
        label: ref.watch(
          settingsProvider.select((v) => v.player.epAutoMarkCompletedThreshold),
        ).toString(),
        enabled: ref.watch(settingsProvider.select((v) => v.player.epAutoMarkCompleted)),
        value: ref.watch(
          settingsProvider.select((v) => v.player.epAutoMarkCompletedThreshold),
        ),
        min: 0,
        max: 100,
        steps: 1,
        onChanged: (v) =>
          ref.read(settingsProvider.notifier).epAutoMarkCompletedThreshold = v.toInt(),
      ),
      SliderSetting(
        title: context.tr.controlsDisplayDuration,
        subtitle: context.tr.controlsDisplayDurationDesc,
        label: ref.watch(
          settingsProvider.select((v) => v.player.controlsDisplayDuration),
        ).toString(),
        value: ref.watch(settingsProvider.select((v) => v.player.controlsDisplayDuration)),
        min: 1,
        max: 30,
        steps: 1,
        onChanged: (v) =>
          ref.read(settingsProvider.notifier).controlsDisplayDuration = v.toInt(),
      ),
      SliderSetting(
        title: context.tr.controlsBackgroundTransparency,
        subtitle: context.tr.controlsBackgroundTransparencyDesc,
        label: ref.watch(
          settingsProvider.select((v) => v.player.controlsBackgroundTransparency),
        ).toString(),
        value: ref.watch(
          settingsProvider.select((v) => v.player.controlsBackgroundTransparency),
        ),
        min: 0,
        max: 100,
        steps: 1,
        onChanged: (v) =>
          ref.read(settingsProvider.notifier).controlsBackgroundTransparency = v.toInt(),
      ),
      SwitchSetting(
        title: context.tr.pauseOnControlsDisplay,
        subtitle: context.tr.pauseOnControlsDisplayDesc,
        value: ref.watch(settingsProvider.select((v) => v.player.controlsPauseOnDisplay)),
        onChanged: (v) => ref.read(settingsProvider.notifier).controlsPauseOnDisplay = v,
      ),
      SliderSetting(
        title: context.tr.introSkipTime,
        subtitle: context.tr.introSkipTimeDesc,
        label: ref.watch(settingsProvider.select((v) => v.player.introSkipTime)).toString(),
        value: ref.watch(settingsProvider.select((v) => v.player.introSkipTime)),
        min: 0,
        max: 500,
        steps: 1,
        onChanged: (v) => ref.read(settingsProvider.notifier).introSkipTime = v.toInt(),
      ),
      SliderSetting(
        title: context.tr.forwardQuickSkipTime,
        subtitle: context.tr.forwardQuickSkipTimeDesc,
        label: ref.watch(
          settingsProvider.select((v) => v.player.quickSkipForwardTime),
        ).toString(),
        value: ref.watch(settingsProvider.select((v) => v.player.quickSkipForwardTime)),
        min: 0,
        max: 30,
        steps: 1,
        onChanged: (v) =>
          ref.read(settingsProvider.notifier).quickSkipForwardTime = v.toInt(),
      ),
      SliderSetting(
        title: context.tr.backwardQuickSkipTime,
        subtitle: context.tr.backwardQuickSkipTimeDesc,
        label: ref.watch(
          settingsProvider.select((v) => v.player.quickSkipBackwardTime),
        ).toString(),
        value: ref.watch(settingsProvider.select((v) => v.player.quickSkipBackwardTime)),
        min: 0,
        max: 30,
        steps: 1,
        onChanged: (v) =>
          ref.read(settingsProvider.notifier).quickSkipBackwardTime = v.toInt(),
      ),
      SliderSetting(
        title: context.tr.quickSkipDisplayDuration,
        subtitle: context.tr.quickSkipDisplayDurationDesc,
        label: ref.watch(
          settingsProvider.select((v) => v.player.quickSkipDisplayDuration),
        ).toString(),
        value: ref.watch(settingsProvider.select((v) => v.player.quickSkipDisplayDuration)),
        min: 0,
        max: 1000,
        steps: 50,
        onChanged: (v) =>
          ref.read(settingsProvider.notifier).quickSkipDisplayDuration = v.toInt(),
      ),
    ],
  );
}
