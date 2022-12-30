
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/widgets/generic_route.dart';
import 'package:nekodroid/widgets/slider_setting.dart';
import 'package:nekodroid/widgets/sliver_title_scrollview.dart';
import 'package:nekodroid/widgets/switch_setting.dart';


class SettingsAnimeRoute extends ConsumerWidget {

  const SettingsAnimeRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => GenericRoute(
    body: SliverTitleScrollview.list(
      title: context.tr.anime,
      children: [
        SwitchSetting(
          title: context.tr.blurThumbs,
          value: ref.watch(settingsProv.select((v) => v.anime.blurThumbs)),
          onChanged: (v) => ref.read(settingsProv.notifier).blurThumbs = v,
        ),
        SliderSetting(
          title: context.tr.blurThumbsSigma,
          label: ref.watch(settingsProv.select((v) => v.anime.blurThumbsSigma)).toString(),
          enabled: ref.watch(settingsProv.select((v) => v.anime.blurThumbs)),
          value: ref.watch(settingsProv.select((v) => v.anime.blurThumbsSigma)),
          min: 1,
          max: 20,
          steps: 1,
          onChanged: (v) => ref.read(settingsProv.notifier).blurThumbsSigma = v.toInt(),
        ),
        SliderSetting(
          title: context.tr.episodeCacheExtent,
          subtitle: context.tr.episodeCacheExtentDesc,
          label: ref.watch(settingsProv.select((v) => v.anime.episodeCacheExtent)).toString(),
          value: ref.watch(settingsProv.select((v) => v.anime.episodeCacheExtent)),
          min: 1,
          max: 20,
          steps: 1,
          onChanged: (v) => ref.read(settingsProv.notifier).episodeCacheExtent = v.toInt(),
        ),
        SwitchSetting(
          title: context.tr.keepEpisodesAlive,
          value: ref.watch(settingsProv.select((v) => v.anime.keepEpisodesAlive)),
          onChanged: (v) => ref.read(settingsProv.notifier).keepEpisodesAlive = v,
        ),
      ],
    ),
  );
}
