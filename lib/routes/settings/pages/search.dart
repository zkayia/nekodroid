
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants/search_filters_persist_mode.dart';
import 'package:nekodroid/constants/widget_title_mixin.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/settings/widgets/radio_setting.dart';
import 'package:nekodroid/routes/settings/widgets/settings_sliver_title_route.dart';
import 'package:nekodroid/routes/settings/widgets/switch_setting.dart';
import 'package:nekodroid/widgets/generic_form_dialog.dart';


class SettingsSearchPage extends ConsumerWidget implements WidgetTitleMixin {

  @override
  final String title;

  const SettingsSearchPage(
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
        title: context.tr.autoOpenSearchBar,
        subtitle: context.tr.autoOpenSearchBarDesc,
        value: ref.watch(settingsProvider.select((v) => v.search.autoOpenBar)),
        onChanged: (v) => ref.read(settingsProvider.notifier).autoOpenBar = v,
      ),
      SwitchSetting(
        title: context.tr.showAllWhenNoQuery,
        subtitle: context.tr.showAllWhenNoQueryDesc,
        value: ref.watch(settingsProvider.select((v) => v.search.showAllWhenNoQuery)),
        onChanged: (v) => ref.read(settingsProvider.notifier).showAllWhenNoQuery = v,
      ),
      SwitchSetting(
        title: context.tr.exitOnClear,
        subtitle: context.tr.exitOnClearDesc,
        value: ref.watch(settingsProvider.select((v) => v.search.clearButtonExitWhenNoQuery)),
        onChanged: (v) => ref.read(settingsProvider.notifier).clearButtonExitWhenNoQuery = v,
      ),
      SwitchSetting(
        title: context.tr.bottomExitButton,
        subtitle: context.tr.bottomExitButtonDesc,
        value: ref.watch(settingsProvider.select((v) => v.search.fabEnabled)),
        onChanged: (v) => ref.read(settingsProvider.notifier).fabEnabled = v,
      ),
      SwitchSetting(
        title: context.tr.bottomExitButtonFloat,
        subtitle: context.tr.bottomExitButtonFloatDesc,
        enabled: ref.watch(settingsProvider.select((v) => v.search.fabEnabled)),
        value: ref.watch(settingsProvider.select((v) => v.search.fabMoveWithKeyboard)),
        onChanged: (v) => ref.read(settingsProvider.notifier).fabMoveWithKeyboard = v,
      ),
      RadioSetting<SearchFiltersPersistMode>(
        title: context.tr.rememberSearchFilter,
        subtitle: context.tr.searchFiltersPersistModes(
          ref.watch(settingsProvider.select((v) => v.search.persistFiltersMode)).name,
        ),
        elements: [
          ...SearchFiltersPersistMode.values.map(
            (e) => GenericFormDialogElement(
              label: context.tr.searchFiltersPersistModes(e.name),
              value: e,
              selected: e == ref.watch(
                settingsProvider.select((v) => v.search.persistFiltersMode),
              ),
            ),
          ),
        ],
        onChanged: (v) => ref.read(settingsProvider.notifier).persistFiltersMode = v,
      ),
    ],
  );
}
