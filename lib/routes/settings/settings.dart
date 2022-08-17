
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/app_localizations.dart';
import 'package:nekodroid/helpers/nav_labels_mode.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/settings/widgets/title_sliver_list_route.dart';


class SettingsRoute extends ConsumerWidget {

  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<IconData, WidgetTitleMixin> settingsCategories = {
      Boxicons.bxs_cog: _SettingsGeneralPage(context.tr.settingsGeneral),
      Boxicons.bxs_home_alt_2: _SettingsHomePage(context.tr.home),
      Boxicons.bx_library: _SettingsLibraryPage(context.tr.library),
      Boxicons.bxs_search: _SettingsSearchPage(context.tr.search),
      Boxicons.bx_dots_horizontal_rounded: _SettingsMorePage(context.tr.more),
      Boxicons.bxs_tv: _SettingsAnimePage(context.tr.anime),
      Boxicons.bx_play: _SettingsPlayerPage(context.tr.player),
      Boxicons.bx_code: _SettingsAdvancedPage(context.tr.settingsAdvanced),
      Boxicons.bxs_mobile: _SettingsUpdatePage(context.tr.settingsUpdate),
      Boxicons.bxs_info_circle: _SettingsAboutPage(context.tr.settingsAbout),
    };
    return TitleSliverListRoute(
      title: context.tr.settings,
      onExitTap: (_) async {
        await ref.read(settingsProvider.notifier).saveToHive();
        return true;
      },
      children: [
        for (final settingsCategory in settingsCategories.entries)
          ...[
            ListTile(
              title: Text(settingsCategory.value.title),
              leading: Icon(settingsCategory.key),
              trailing: const Icon(Boxicons.bxs_chevron_right),
              onTap: () => _pushPageRoute(context, settingsCategory.value),
            ),
            if (settingsCategory != settingsCategories.entries.last)
              const SizedBox(height: kPaddingSecond),
          ],
      ],
    );
  }

  void _pushPageRoute(BuildContext context, Widget page) => Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => page),
  );
}

// TODO: custom form widgets for all categories & types
// TODO: global reset button
// TODO: display default value label?

mixin WidgetTitleMixin on Widget {
  String get title;
}

class _SettingsGeneralPage extends ConsumerWidget implements WidgetTitleMixin {

  @override
  final String title;

  const _SettingsGeneralPage(this.title);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagesText = [
      context.tr.home,
      context.tr.library,
      context.tr.search,
      context.tr.more,
    ];
    return TitleSliverListRoute(
      title: title,
      children: [
        ListTile(
          title: Text(context.tr.settingsTheme),
          leading: const Icon(Boxicons.bxs_palette),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingSecond),
          child: Column(
            children: [
              for (final themeMode in ThemeMode.values)
                RadioListTile(
                  title: Text(context.tr.settingsThemes(themeMode.name)),
                  value: themeMode,
                  groupValue: ref.watch(settingsProvider.select((value) => value.themeMode)),
                  onChanged: (_) => ref.read(settingsProvider.notifier).themeMode = themeMode,
                ),
              SwitchListTile(
                title: Text(context.tr.settingsUseAmoled),
                value: ref.watch(settingsProvider.select((value) => value.useAmoled)),
                onChanged: (bool value) => ref.read(settingsProvider.notifier).useAmoled = value,
              ),
            ],
          ),
        ),
        ListTile(
          title: Text(context.tr.settingsLocale),
          leading: const Icon(Boxicons.bx_text),
        ),
        RadioListTile<String>(
          title: Text(context.tr.settingsDeviceLocale),
          value: "system",
          groupValue: ref.watch(settingsProvider.select((value) => value.locale)),
          onChanged: (_) => ref.read(settingsProvider.notifier).locale = "system",
        ),
        for (final locale in AppLocalizations.supportedLocales)
          RadioListTile<String>(
            title: Text(lookupAppLocalizations(locale).localeDisplayName),
            value: locale.toString(),
            groupValue: ref.watch(settingsProvider.select((value) => value.locale)),
            onChanged: (_) => ref.read(settingsProvider.notifier).locale = locale.toString(),
          ),
        ListTile(
          title: Text(context.tr.settingsNavLabel),
          leading: const Icon(Boxicons.bxs_label),
        ),
        for (final navLabelMode in NavLabelsMode.values)
          RadioListTile(
            title: Text(context.tr.settingsNavLabels(navLabelMode.name)),
            value: navLabelMode,
            groupValue: ref.watch(
              settingsProvider.select((value) => value.navLabelsMode),
            ),
            onChanged: (_) => ref.read(settingsProvider.notifier).navLabelsMode = navLabelMode,
          ),
        ListTile(
          title: Text(context.tr.settingsDefaultPage),
          leading: const Icon(Boxicons.bxs_home),
        ),
        for (var i = 0; i < pagesText.length; i++)
          RadioListTile(
            title: Text(pagesText.elementAt(i)),
            value: i,
            groupValue: ref.watch(settingsProvider.select((value) => value.defaultPage)),
            onChanged: (_) => ref.read(settingsProvider.notifier).defaultPage = i,
          ),
      ],
    );
  }
}

class _SettingsHomePage extends ConsumerWidget implements WidgetTitleMixin {

  @override
  final String title;

  const _SettingsHomePage(this.title);

  @override
  Widget build(BuildContext context, WidgetRef ref) => TitleSliverListRoute(
    title: title,
    children: [
      ListTile(
        title: Text(context.tr.carouselItemCount),
        leading: const Icon(Boxicons.bxs_carousel),
      ),
      Slider(
        min: 3,
        max: 10,
        divisions: 7,
        value: ref.watch(settingsProvider.select((value) => value.carouselItemCount)).toDouble(),
        label: ref.watch(settingsProvider.select((value) => value.carouselItemCount)).toString(),
        onChanged: (double value) =>
          ref.read(settingsProvider.notifier).carouselItemCount = value.toInt(),
      ),
    ],
  );
}

// TODO: sliders value display
class _SettingsLibraryPage extends ConsumerWidget implements WidgetTitleMixin {

  @override
  final String title;

  const _SettingsLibraryPage(this.title);

  @override
  Widget build(BuildContext context, WidgetRef ref) => TitleSliverListRoute(
    title: title,
    children: const [],
  );
}

class _SettingsSearchPage extends ConsumerWidget implements WidgetTitleMixin {

  @override
  final String title;

  const _SettingsSearchPage(this.title);

  @override
  Widget build(BuildContext context, WidgetRef ref) => TitleSliverListRoute(
    title: title,
    children: const [],
  );
}

class _SettingsMorePage extends ConsumerWidget implements WidgetTitleMixin {

  @override
  final String title;

  const _SettingsMorePage(this.title);

  @override
  Widget build(BuildContext context, WidgetRef ref) => TitleSliverListRoute(
    title: context.tr.settingsAdvanced,
    children: const [],
  );
}

class _SettingsAnimePage extends ConsumerWidget implements WidgetTitleMixin {

  @override
  final String title;

  const _SettingsAnimePage(this.title);

  @override
  Widget build(BuildContext context, WidgetRef ref) => TitleSliverListRoute(
    title: title,
    children: [
      SwitchListTile(
        title: Text(context.tr.blurThumbs),
        value: ref.watch(settingsProvider.select((value) => value.blurThumbs)),
        onChanged: (bool value) =>
          ref.read(settingsProvider.notifier).blurThumbs = value,
      ),
      ListTile(title: Text(context.tr.blurThumbsSigma)),
      Slider(
        min: 1,
        max: 20,
        divisions: 19,
        value: ref.watch(settingsProvider.select((value) => value.blurThumbsSigma)),
        label: ref.watch(
          settingsProvider.select((value) => value.blurThumbsSigma),
        ).toInt().toString(),
        onChanged: (double value) =>
          ref.read(settingsProvider.notifier).blurThumbsSigma = value,
      ),
    ],
  );
}

class _SettingsPlayerPage extends ConsumerWidget implements WidgetTitleMixin {

  @override
  final String title;

  const _SettingsPlayerPage(this.title);

  @override
  Widget build(BuildContext context, WidgetRef ref) => TitleSliverListRoute(
    title: title,
    children: const [],
  );
}

class _SettingsAdvancedPage extends ConsumerWidget implements WidgetTitleMixin {

  @override
  final String title;

  const _SettingsAdvancedPage(this.title);

  @override
  Widget build(BuildContext context, WidgetRef ref) => TitleSliverListRoute(
    title: title,
    children: const [],
  );
}

// TODO: app update system
class _SettingsUpdatePage extends ConsumerWidget implements WidgetTitleMixin {

  @override
  final String title;

  const _SettingsUpdatePage(this.title);

  @override
  Widget build(BuildContext context, WidgetRef ref) => TitleSliverListRoute(
    title: title,
    children: const [],
  );
}

// TODO: fill about page (app version, github link, license, nekosama link, flutter icon, ...)
class _SettingsAboutPage extends ConsumerWidget implements WidgetTitleMixin {

  @override
  final String title;

  const _SettingsAboutPage(this.title);

  @override
  Widget build(BuildContext context, WidgetRef ref) => TitleSliverListRoute(
    title: title,
    children: const [],
  );
}
