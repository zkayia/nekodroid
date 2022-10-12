
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/constants/widget_title_mixin.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/models/library_list.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/settings/pages/library.lists.dart';
import 'package:nekodroid/routes/settings/widgets/radio_setting.dart';
import 'package:nekodroid/routes/settings/widgets/settings_sliver_title_route.dart';
import 'package:nekodroid/routes/settings/widgets/switch_setting.dart';
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
    final tabs = [
      LibraryList(
        position: 0,
        label: context.tr.libraryHistory,
      ),
      LibraryList(
        position: 1,
        label: context.tr.libraryFavorites,
      ),
      ...?ref.watch(settingsProvider.select((v) => v.library.lists))
    ];
    return SettingsSliverTitleRoute(
      title: title,
      children: [
        SwitchSetting(
          title: context.tr.enableTabbarScrolling,
          value: ref.watch(settingsProvider.select((v) => v.library.enableTabbarScrolling)),
          onChanged: (v) => ref.read(settingsProvider.notifier).enableTabbarScrolling = v,
        ),
        RadioSetting<int>(
          title: context.tr.defaultTab,
          subtitle: tabs.elementAt(
            ref.watch(settingsProvider.select((v) => v.library.defaultTab)),
          ).label,
          elements: [
            ...tabs.map(
              (e) => GenericFormDialogElement(
                label: e.label,
                value: e.position,
                selected: e.position == ref.watch(
                  settingsProvider.select((v) => v.library.defaultTab),
                ),
              ),
            ),
          ],
          onChanged: (v) => ref.read(settingsProvider.notifier).defaultTab = v,
        ),
        SwitchSetting(
          title: context.tr.libraryHistory,
          value: ref.watch(settingsProvider.select((v) => v.library.enableHistory)),
          onChanged: (v) => ref.read(settingsProvider.notifier).enableHistory = v,
        ),
        SwitchSetting(
          title: context.tr.libraryFavorites,
          value: ref.watch(settingsProvider.select((v) => v.library.enableFavorites)),
          onChanged: (v) => ref.read(settingsProvider.notifier).enableFavorites = v,
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: kPaddingSecond,
          ),
          title: const Text("Lists config"),
          subtitle: const Text("Add/delete/edit lists in the library"),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SettingsLibraryListsPage()),
          ),
        ),
      ],
    );
}
}
