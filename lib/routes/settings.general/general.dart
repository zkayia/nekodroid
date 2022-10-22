
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants/nav_labels_mode.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/models/generic_form_dialog_element.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/widgets/radio_setting.dart';
import 'package:nekodroid/widgets/settings_sliver_title_route.dart';
import 'package:nekodroid/widgets/switch_setting.dart';


class SettingsGeneralRoute extends ConsumerWidget {

  const SettingsGeneralRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagesText = [
      context.tr.home,
      context.tr.library,
      context.tr.search,
      context.tr.more,
    ];
    return SettingsSliverTitleRoute(
      title: context.tr.settingsGeneral,
      children: [
        RadioSetting<ThemeMode>(
          title: context.tr.settingsTheme,
          subtitle: context.tr.settingsThemes(
            ref.watch(settingsProv.select((v) => v.general.themeMode)).name,
          ),
          elements: [
            ...ThemeMode.values.map(
              (e) => GenericFormDialogElement(
                label: context.tr.settingsThemes(e.name),
                value: e,
                selected: e == ref.watch(
                  settingsProv.select((v) => v.general.themeMode),
                ),
              ),
            ),
          ],
          onChanged: (v) => ref.read(settingsProv.notifier).themeMode = v,
        ),
        SwitchSetting(
          title: context.tr.settingsUseAmoled,
          subtitle: context.tr.settingsUseAmoledDesc,
          value: ref.watch(settingsProv.select((v) => v.general.useAmoled)),
          onChanged: (v) => ref.read(settingsProv.notifier).useAmoled = v,
        ),
        RadioSetting<String>(
          title: context.tr.settingsLocale,
          subtitle: ref.watch(settingsProv.select((v) => v.general.locale)) == "system"
            ? context.tr.settingsDeviceLocale
            : context.tr.localeDisplayName,
          elements: [
            GenericFormDialogElement(
              label: context.tr.settingsDeviceLocale,
              value: "system",
              selected: "system" == ref.watch(
                settingsProv.select((v) => v.general.locale),
              ),
            ),
            for (final locale in AppLocalizations.supportedLocales)
              GenericFormDialogElement(
                label: lookupAppLocalizations(locale).localeDisplayName,
                value: locale.toLanguageTag(),
                selected: locale.toLanguageTag() == ref.watch(
                  settingsProv.select((v) => v.general.locale),
                ),
              ),
          ],
          onChanged: (v) => ref.read(settingsProv.notifier).locale = v,
        ),
        RadioSetting<NavLabelsMode>(
          title: context.tr.settingsNavLabel,
          subtitle: context.tr.settingsNavLabels(
            ref.watch(settingsProv.select((v) => v.general.navLabelsMode)).name,
          ),
          elements: [
            ...NavLabelsMode.values.map(
              (e) => GenericFormDialogElement(
                label: context.tr.settingsNavLabels(e.name),
                value: e,
                selected: e == ref.watch(
                  settingsProv.select((v) => v.general.navLabelsMode),
                ),
              ),
            ),
          ],
          onChanged: (v) => ref.read(settingsProv.notifier).navLabelsMode = v,
        ),
        RadioSetting<int>(
          title: context.tr.settingsDefaultPage,
          subtitle: pagesText.elementAt(
            ref.watch(settingsProv.select((v) => v.general.defaultPage)),
          ),
          elements: [
            for (var i = 0; i < pagesText.length; i++)
              GenericFormDialogElement(
                label: pagesText.elementAt(i),
                value: i,
                selected: i == ref.watch(
                  settingsProv.select((v) => v.general.defaultPage),
                ),
              ),
          ],
          onChanged: (v) => ref.read(settingsProv.notifier).defaultPage = v,
        ),
        SwitchSetting(
          title: context.tr.enableNavbarSwipe,
          subtitle: context.tr.enableNavbarSwipeDesc,
          value: ref.watch(settingsProv.select((v) => v.general.enableNavbarSwipe)),
          onChanged: (v) => ref.read(settingsProv.notifier).enableNavbarSwipe = v,
        ),
        SwitchSetting(
          title: context.tr.reverseNavbarSwipe,
          subtitle: context.tr.reverseNavbarSwipeDesc,
          enabled: ref.watch(settingsProv.select((v) => v.general.enableNavbarSwipe)),
          value: ref.watch(settingsProv.select((v) => v.general.reverseNavbarSwipe)),
          onChanged: (v) => ref.read(settingsProv.notifier).reverseNavbarSwipe = v,
        ),
      ],
    );
  }
}
