
import 'package:boxicons/boxicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/helpers/nav_labels_mode.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/widgets/generic_route.dart';


class SettingsRoute extends ConsumerWidget {

	final themeModeText = {
		ThemeMode.system: "system".tr(),
		ThemeMode.dark: "dark".tr(),
		ThemeMode.light: "light".tr(),
	};
	final pagesText = [
		"home".tr(),
		"library".tr(),
		"more".tr(),
	];
	final navLabelsText = {
		NavLabelsMode.all: "always-active".tr(),
		NavLabelsMode.disabled: "never-active".tr(),
		NavLabelsMode.onlySelected: "only-on-selected".tr(),
	};

	SettingsRoute({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) => GenericRoute(
		title: "settings".tr(),
		onExitTap: (context) {
			ref.read(settingsProvider.notifier).saveToHive();
			Navigator.pop(context);
		},
		body: ListView(
			physics: kDefaultScrollPhysics,
			padding: const EdgeInsets.only(
				top: kPaddingSecond * 2 + kTopBarHeight,
				left: kPaddingMain,
				right: kPaddingMain,
				bottom: kPaddingSecond + kFabSize + 16,
			),
			children: [
				ListTile(
					// leading: const ListTileIcon(UniconsLine.home_alt),
					title: const Text("theme").tr(),
					trailing: ref.watch(settingsProvider.select((value) => value.themeMode))
					== kDefaultSettings.themeMode
						? null
						: IconButton(
							icon: const Icon(Boxicons.bx_redo),
							onPressed: () =>
								ref.read(settingsProvider.notifier).resetThemeMode(),
						),
				),
				Padding(
					padding: const EdgeInsets.only(left: kPaddingSecond),
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
						],
					),
				),
				SwitchListTile(
					title: const Text("use-amoled").tr(),
					value: ref.watch(settingsProvider.select((value) => value.useAmoled)),
					onChanged: (bool value) =>
						ref.read(settingsProvider.notifier).useAmoled = value,
				),
				ListTile(
					// leading: const ListTileIcon(UniconsLine.home_alt),
					title: const Text("locale").tr(),
				),
				Padding(
					padding: const EdgeInsets.only(left: kPaddingSecond),
					child: Column(
						children: [
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
						],
					),
				),
				ListTile(
					// leading: const ListTileIcon(UniconsLine.home_alt),
					title: const Text("default-page").tr(),
					trailing: ref.watch(settingsProvider.select((value) => value.defaultPage))
					== kDefaultSettings.defaultPage
						? null
						: IconButton(
							icon: const Icon(Boxicons.bx_redo),
							onPressed: () =>
								ref.read(settingsProvider.notifier).resetDefaultPage(),
						),
				),
				Padding(
					padding: const EdgeInsets.only(left: kPaddingSecond),
					child: Column(
						children: [
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
					),
				),
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
				ListTile(
					title: const Text("blur-thumbs-sigma").tr(),
					trailing: ref.watch(settingsProvider.select((value) => value.blurThumbsSigma))
					== kDefaultSettings.blurThumbsSigma
						? null
						: IconButton(
							icon: const Icon(Boxicons.bx_redo),
							onPressed: () =>
								ref.read(settingsProvider.notifier).resetBlurThumbsSigma(),
						),
				),
				Slider(
					min: 1,
					max: 20,
					divisions: 20,
					value: ref.watch(settingsProvider.select((value) => value.blurThumbsSigma)),
					onChanged: (double value) =>
						ref.read(settingsProvider.notifier).blurThumbsSigma = value,
				),
				ListTile(
					// leading: const ListTileIcon(UniconsLine.label),
					title: const Text("nav-labels").tr(),
					trailing: ref.watch(settingsProvider.select((value) => value.navLabelsMode))
					== kDefaultSettings.navLabelsMode
						? null
						: IconButton(
							icon: const Icon(Boxicons.bx_redo),
							onPressed: () =>
								ref.read(settingsProvider.notifier).resetNavLabelsMode(),
						),
				),
				Padding(
					padding: const EdgeInsets.only(left: kPaddingSecond),
					child: Column(
						children: [
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
						],
					),
				),
				ListTile(
					title: const Text("carousel-item-count").tr(),
					trailing: ref.watch(settingsProvider.select((value) => value.carouselItemCount))
					== kDefaultSettings.carouselItemCount
						? null
						: IconButton(
							icon: const Icon(Boxicons.bx_redo),
							onPressed: () =>
								ref.read(settingsProvider.notifier).resetCarouselItemCount(),
						),
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
		),
	);
}
