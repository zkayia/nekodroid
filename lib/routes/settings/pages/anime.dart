
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants/widget_title_mixin.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/settings/widgets/settings_sliver_title_route.dart';
import 'package:nekodroid/routes/settings/widgets/slider_setting.dart';
import 'package:nekodroid/routes/settings/widgets/switch_setting.dart';


class SettingsAnimePage extends ConsumerWidget implements WidgetTitleMixin {

  @override
  final String title;

  const SettingsAnimePage(
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
        title: context.tr.blurThumbs,
        value: ref.watch(settingsProvider.select((value) => value.anime.blurThumbs)),
        onChanged: (bool value) =>
          ref.read(settingsProvider.notifier).blurThumbs = value,
      ),
      SliderSetting(
        title: context.tr.blurThumbsSigma,
        label: ref.watch(
          settingsProvider.select((value) => value.anime.blurThumbsSigma),
        ).toString(),
        enabled: ref.watch(settingsProvider.select((value) => value.anime.blurThumbs)),
        value: ref.watch(settingsProvider.select((value) => value.anime.blurThumbsSigma)),
        min: 1,
        max: 20,
        steps: 1,
        onChanged: (v) => ref.read(settingsProvider.notifier).blurThumbsSigma = v.toInt(),
      ),
    ],
  );
}
