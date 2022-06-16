
import 'package:boxicons/boxicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/helpers/nav_labels_mode.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/settings/widgets/title_sliver_list_route.dart';


class SettingsRoute extends ConsumerWidget {

	final Map<IconData, WidgetTitleMixin> settingsCategories = {
		Boxicons.bxs_cog: _SettingsGeneralPage("general".tr()),
		Boxicons.bxs_home_alt_2: _SettingsHomePage("home".tr()),
		Boxicons.bx_library: _SettingsLibraryPage("library".tr()),
		Boxicons.bxs_search: _SettingsSearchPage("search".tr()),
		Boxicons.bx_dots_horizontal_rounded: _SettingsMorePage("more".tr()),
		Boxicons.bxs_tv: _SettingsAnimePage("anime".tr()),
		Boxicons.bx_play: _SettingsPlayerPage("player".tr()),
		Boxicons.bx_code: _SettingsAdvancedPage("advanced".tr()),
		Boxicons.bxs_mobile: _SettingsUpdatePage("update".tr()),
		Boxicons.bxs_info_circle: _SettingsAboutPage("about".tr()),
	};

	SettingsRoute({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) => TitleSliverListRoute(
		title: "settings".tr(),
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

	void _pushPageRoute(BuildContext context, Widget page) => Navigator.of(context).push(
		MaterialPageRoute(builder: (context) => page),
	);
}

// TODO: custom form widgets for all categories & types
// TODO: global reset button
// TODO: display default value label?

mixin WidgetTitleMixin on Widget {
	String get title;
}

class _SettingsGeneralPage extends ConsumerWidget implements WidgetTitleMixin {

	final themeModeText = {
		ThemeMode.system: "system".tr(),
		ThemeMode.dark: "dark".tr(),
		ThemeMode.light: "light".tr(),
	};
	final navLabelsText = {
		NavLabelsMode.all: "always-active".tr(),
		NavLabelsMode.disabled: "never-active".tr(),
		NavLabelsMode.onlySelected: "only-on-selected".tr(),
	};
	final pagesText = [
		"home".tr(),
		"library".tr(),
		"search".tr(),
		"more".tr(),
	];
  @override
	final String title;

	_SettingsGeneralPage(this.title);

	@override
	Widget build(BuildContext context, WidgetRef ref) => TitleSliverListRoute(
		title: title,
		children: [
			ListTile(
				title: const Text("theme").tr(),
				leading: const Icon(Boxicons.bxs_palette),
			),
			Padding(
				padding: const EdgeInsets.symmetric(horizontal: kPaddingSecond),
				child: Column(
					children: [
						for (final themeMode in themeModeText.entries)
							RadioListTile(
								title: Text(themeMode.value),
								value: themeMode.key,
								groupValue: ref.watch(settingsProvider.select((value) => value.themeMode)),
								onChanged: (ThemeMode? value) {
									if (value != null) {
										ref.read(settingsProvider.notifier).themeMode = value;
									}
								},
							),
						SwitchListTile(
							title: const Text("use-amoled").tr(),
							value: ref.watch(settingsProvider.select((value) => value.useAmoled)),
							onChanged: (bool value) =>
								ref.read(settingsProvider.notifier).useAmoled = value,
						),
					],
				),
			),
			ListTile(
				title: const Text("locale").tr(),
				leading: const Icon(Boxicons.bx_text),
			),
			RadioListTile(
				title: const Text("system").tr(),
				value: context.deviceLocale,
				groupValue: context.locale,
				onChanged: (Locale? value) {
					if (value != null) {
						context.resetLocale();
					}
				},
			),
			RadioListTile(
				title: const Text("Français"),
				value: const Locale("fr"),
				groupValue: context.locale,
				onChanged: (Locale? value) {
					if (value != null) {
						context.setLocale(value);
					}
				},
			),
			RadioListTile(
				title: const Text("English"),
				value: const Locale("en"),
				groupValue: context.locale,
				onChanged: (Locale? value) {
					if (value != null) {
						context.setLocale(value);
					}
				},
			),
			ListTile(
				title: const Text("nav-labels").tr(),
				leading: const Icon(Boxicons.bxs_label),
			),
			for (final navLabelMode in navLabelsText.entries)
				RadioListTile(
					title: Text(navLabelMode.value),
					value: navLabelMode.key,
					groupValue: ref.watch(
						settingsProvider.select((value) => value.navLabelsMode),
					),
					onChanged: (NavLabelsMode? value) {
						if (value != null) {
							ref.read(settingsProvider.notifier).navLabelsMode = value;
						}
					},
				),
			ListTile(
				title: const Text("default-page").tr(),
				leading: const Icon(Boxicons.bxs_home),
			),
			for (var i = 0; i < pagesText.length; i++)
				RadioListTile(
					title: Text(pagesText.elementAt(i)),
					value: i,
					groupValue: ref.watch(settingsProvider.select((value) => value.defaultPage)),
					onChanged: (int? value) {
						if (value != null) {
							ref.read(settingsProvider.notifier).defaultPage = value;
						}
					},
				),
		],
	);
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
				title: const Text("carousel-item-count").tr(),
				leading: const Icon(Boxicons.bxs_carousel),
			),
			Slider(
				min: 3,
				max: 10,
				divisions: 9,
				value: ref.watch(settingsProvider.select((value) => value.carouselItemCount)).toDouble(),
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
		title: "advanced".tr(),
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
				title: const Text("blur-thumbs").tr(),
				value: ref.watch(settingsProvider.select((value) => value.blurThumbs)),
				onChanged: (bool value) =>
					ref.read(settingsProvider.notifier).blurThumbs = value,
			),
			SwitchListTile(
				title: const Text("show-blur-thumbs-switch").tr(),
				value: ref.watch(settingsProvider.select((value) => value.blurThumbsShowSwitch)),
				onChanged: (bool value) =>
					ref.read(settingsProvider.notifier).blurThumbsShowSwitch = value,
			),
			ListTile(title: const Text("blur-thumbs-sigma").tr()),
			Slider(
				min: 1,
				max: 20,
				divisions: 20,
				value: ref.watch(settingsProvider.select((value) => value.blurThumbsSigma)),
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
		title: "update".tr(),
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
		title: "about".tr(),
		children: const [],
	);
}
