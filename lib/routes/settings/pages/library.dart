
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/constants/widget_title_mixin.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/lists.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/settings/pages/library.lists.dart';
import 'package:nekodroid/routes/settings/widgets/radio_setting.dart';
import 'package:nekodroid/routes/settings/widgets/settings_sliver_title_route.dart';
import 'package:nekodroid/routes/settings/widgets/switch_setting.dart';
import 'package:nekodroid/schemas/isar_anime_list.dart';
import 'package:nekodroid/widgets/generic_form_dialog.dart';


class SettingsLibraryPage extends ConsumerWidget implements WidgetTitleMixin {

  @override
  final String title;

  const SettingsLibraryPage(
    this.title,
    {
      super.key,
    }
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = <IsarAnimeList>[
      if (ref.watch(settingsProvider.select((v) => v.library.enableHistory)))
        IsarAnimeList(
          position: -2,
          name: context.tr.libraryHistory,
        ),
      if (ref.watch(settingsProvider.select((v) => v.library.enableFavorites)))
        IsarAnimeList(
          position: -1,
          name: context.tr.libraryFavorites,
        ),
      ...ref.watch(listsProvider).when(
        data: (data) => data,
        error: (_, __) => const [],
        loading: () => const [],
      ),
    ];
    final defaultTab = tabs.where(
      (e) => e.position == ref.watch(settingsProvider.select((v) => v.library.defaultTab)),
    );
    return SettingsSliverTitleRoute(
      title: title,
      children: [
        SwitchSetting(
          title: context.tr.enableTabbarScrolling,
          value: ref.watch(settingsProvider.select((v) => v.library.enableTabbarScrolling)),
          onChanged: (v) => ref.read(settingsProvider.notifier).enableTabbarScrolling = v,
        ),
        RadioSetting<int>(
          enabled: tabs.isNotEmpty,
          title: context.tr.defaultTab,
          subtitle: defaultTab.isEmpty ? null : defaultTab.first.name,
          elements: [
            ...tabs.map(
              (e) => GenericFormDialogElement(
                label: e.name,
                value: e.position,
                selected: e.position == ref.watch(
                  settingsProvider.select((v) => v.library.defaultTab),
                ),
              ),
            ),
          ],
          onChanged: (v) => ref.read(settingsProvider.notifier).defaultTab = v,
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: kPaddingSecond,
          ),
          title: const Text("Lists config"), //TODO: tr
          subtitle: const Text("Add/delete/edit lists in the library"), //TODO: tr
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SettingsLibraryListsPage()),
          ),
        ),
      ],
    );
}
}
