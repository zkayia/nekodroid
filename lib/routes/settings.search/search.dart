
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/widgets/settings_sliver_title_route.dart';
import 'package:nekodroid/widgets/switch_setting.dart';


class SettingsSearchRoute extends ConsumerWidget {

  const SettingsSearchRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SettingsSliverTitleRoute(
    title: context.tr.search,
    children: [
      SwitchSetting(
        title: context.tr.autoOpenSearchBar,
        subtitle: context.tr.autoOpenSearchBarDesc,
        value: ref.watch(settingsProv.select((v) => v.search.autoOpenBar)),
        onChanged: (v) => ref.read(settingsProv.notifier).autoOpenBar = v,
      ),
      SwitchSetting(
        title: context.tr.showAllWhenNoQuery,
        subtitle: context.tr.showAllWhenNoQueryDesc,
        value: ref.watch(settingsProv.select((v) => v.search.showAllWhenNoQuery)),
        onChanged: (v) => ref.read(settingsProv.notifier).showAllWhenNoQuery = v,
      ),
      SwitchSetting(
        title: context.tr.exitOnClear,
        subtitle: context.tr.exitOnClearDesc,
        value: ref.watch(settingsProv.select((v) => v.search.clearButtonExitWhenNoQuery)),
        onChanged: (v) => ref.read(settingsProv.notifier).clearButtonExitWhenNoQuery = v,
      ),
      SwitchSetting(
        title: context.tr.bottomExitButton,
        subtitle: context.tr.bottomExitButtonDesc,
        value: ref.watch(settingsProv.select((v) => v.search.fabEnabled)),
        onChanged: (v) => ref.read(settingsProv.notifier).fabEnabled = v,
      ),
      SwitchSetting(
        title: context.tr.bottomExitButtonFloat,
        subtitle: context.tr.bottomExitButtonFloatDesc,
        enabled: ref.watch(settingsProv.select((v) => v.search.fabEnabled)),
        value: ref.watch(settingsProv.select((v) => v.search.fabMoveWithKeyboard)),
        onChanged: (v) => ref.read(settingsProv.notifier).fabMoveWithKeyboard = v,
      ),
    ],
  );
}
