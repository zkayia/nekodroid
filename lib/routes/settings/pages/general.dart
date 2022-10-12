
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants/nav_labels_mode.dart';
import 'package:nekodroid/constants/widget_title_mixin.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/settings/widgets/radio_setting.dart';
import 'package:nekodroid/routes/settings/widgets/settings_sliver_title_route.dart';
import 'package:nekodroid/routes/settings/widgets/switch_setting.dart';
import 'package:nekodroid/widgets/generic_form_dialog.dart';


class SettingsGeneralPage extends ConsumerWidget implements WidgetTitleMixin {

  @override
  final String title;

  const SettingsGeneralPage(
    this.title,
    {
      super.key,
    }
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagesText = [
      context.tr.home,
      context.tr.library,
      context.tr.search,
      context.tr.more,
    ];
    return SettingsSliverTitleRoute(
      title: title,
      children: [
        RadioSetting<ThemeMode>(
          title: context.tr.settingsTheme,
          subtitle: context.tr.settingsThemes(
            ref.watch(settingsProvider.select((v) => v.general.themeMode)).name,
          ),
          elements: [
            ...ThemeMode.values.map(
              (e) => GenericFormDialogElement(
                label: context.tr.settingsThemes(e.name),
                value: e,
                selected: e == ref.watch(
                  settingsProvider.select((v) => v.general.themeMode),
                ),
              ),
            ),
          ],
          onChanged: (v) => ref.read(settingsProvider.notifier).themeMode = v,
        ),
        SwitchSetting(
          title: context.tr.settingsUseAmoled,
          subtitle: context.tr.settingsUseAmoledDesc,
          value: ref.watch(settingsProvider.select((v) => v.general.useAmoled)),
          onChanged: (v) => ref.read(settingsProvider.notifier).useAmoled = v,
        ),
        RadioSetting<String>(
          title: context.tr.settingsLocale,
          subtitle: ref.watch(settingsProvider.select((v) => v.general.locale)) == "system"
            ? context.tr.settingsDeviceLocale
            : context.tr.localeDisplayName,
          elements: [
            GenericFormDialogElement(
              label: context.tr.settingsDeviceLocale,
              value: "system",
              selected: "system" == ref.watch(
                settingsProvider.select((v) => v.general.locale),
              ),
            ),
            for (final locale in AppLocalizations.supportedLocales)
              GenericFormDialogElement(
                label: lookupAppLocalizations(locale).localeDisplayName,
                value: locale.toLanguageTag(),
                selected: locale.toLanguageTag() == ref.watch(
                  settingsProvider.select((v) => v.general.locale),
                ),
              ),
          ],
          onChanged: (v) => ref.read(settingsProvider.notifier).locale = v,
        ),
        RadioSetting<NavLabelsMode>(
          title: context.tr.settingsNavLabel,
          subtitle: context.tr.settingsNavLabels(
            ref.watch(settingsProvider.select((v) => v.general.navLabelsMode)).name,
          ),
          elements: [
            ...NavLabelsMode.values.map(
              (e) => GenericFormDialogElement(
                label: context.tr.settingsNavLabels(e.name),
                value: e,
                selected: e == ref.watch(
                  settingsProvider.select((v) => v.general.navLabelsMode),
                ),
              ),
            ),
          ],
          onChanged: (v) => ref.read(settingsProvider.notifier).navLabelsMode = v,
        ),
        RadioSetting<int>(
          title: context.tr.settingsDefaultPage,
          subtitle: pagesText.elementAt(
            ref.watch(settingsProvider.select((v) => v.general.defaultPage)),
          ),
          elements: [
            for (var i = 0; i < pagesText.length; i++)
              GenericFormDialogElement(
                label: pagesText.elementAt(i),
                value: i,
                selected: i == ref.watch(
                  settingsProvider.select((v) => v.general.defaultPage),
                ),
              ),
          ],
          onChanged: (v) => ref.read(settingsProvider.notifier).defaultPage = v,
        ),
      ],
    );
  }
}
