
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/models/generic_form_dialog_element.dart';
import 'package:nekodroid/provider/lists.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/widgets/generic_route.dart';
import 'package:nekodroid/widgets/radio_setting.dart';
import 'package:nekodroid/widgets/sliver_title_scrollview.dart';
import 'package:nekodroid/widgets/switch_setting.dart';
import 'package:nekodroid/schemas/isar_anime_list.dart';


class SettingsLibraryRoute extends ConsumerWidget {

  const SettingsLibraryRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = <IsarAnimeList>[
      if (ref.watch(settingsProv.select((v) => v.library.enableHistory)))
        IsarAnimeList(
          position: -2,
          name: context.tr.libraryHistory,
        ),
      if (ref.watch(settingsProv.select((v) => v.library.enableFavorites)))
        IsarAnimeList(
          position: -1,
          name: context.tr.libraryFavorites,
        ),
      ...ref.watch(listsProv).when(
        data: (data) => data,
        error: (_, __) => const [],
        loading: () => const [],
      ),
    ];
    final defaultTab = tabs.where(
      (e) => e.position == ref.watch(settingsProv.select((v) => v.library.defaultTab)),
    );
    return GenericRoute(
      body: SliverTitleScrollview.list(
        title: context.tr.library,
        children: [
          SwitchSetting(
            title: context.tr.enableTabbarScrolling,
            value: ref.watch(settingsProv.select((v) => v.library.enableTabbarScrolling)),
            onChanged: (v) => ref.read(settingsProv.notifier).enableTabbarScrolling = v,
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
                    settingsProv.select((v) => v.library.defaultTab),
                  ),
                ),
              ),
            ],
            onChanged: (v) => ref.read(settingsProv.notifier).defaultTab = v,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: kPaddingSecond,
            ),
            title: Text(context.tr.listsConfig),
            subtitle: Text(context.tr.listsConfigDesc),
            onTap: () => Navigator.of(context).pushNamed("/settings/library/lists"),
          ),
        ],
      ),
    );
}
}
