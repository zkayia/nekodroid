
import 'package:boxicons/boxicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/helpers/nav_labels_mode.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/widgets/generic_route.dart';


final _scrollControllerProvider = Provider.autoDispose<ScrollController>(
	(ref) {
		final controller = ScrollController();
		controller.addListener(
			() => ref.watch(_scrollOffsetProvider.notifier).update(
				(state) => controller.offset,
			),
		);
		ref.onDispose(() => controller.dispose());
		return controller;
	},
);

final _scrollOffsetProvider = StateProvider.autoDispose<double>((ref) => 0);

class SettingsRoute extends ConsumerWidget {

	final Map<String, MapEntry<IconData, Widget>> settingsCategories = {
		"theme".tr(): MapEntry(
			Boxicons.bxs_palette,
			_SettingsThemePage(),
		),
		"locale".tr(): const MapEntry(
			Boxicons.bx_text,
			_SettingsLocalePage(),
		),
		"appearance".tr(): MapEntry(
			Boxicons.bxs_paint_roll,
			_SettingsAppearancePage(),
		),
		"advanced".tr(): MapEntry(
			Boxicons.bx_code,
			_SettingsAdvancedPage(),
		),
		"update".tr(): const MapEntry(
			Boxicons.bxs_mobile,
			_SettingsUpdatePage(),
		),
		"about".tr(): const MapEntry(
			Boxicons.bxs_info_circle,
			_SettingsAboutPage(),
		),
	};


	SettingsRoute({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) => GenericRoute(
		body: CustomScrollView(
			physics: kDefaultScrollPhysics,
			controller: ref.watch(_scrollControllerProvider),
			shrinkWrap: true,
			slivers: [
				const _SettingsSliverHeader(),
				SliverPadding(
					padding: const EdgeInsets.only(
						top: kPaddingSecond,
						left: kPaddingMain,
						right: kPaddingMain,
						bottom: kPaddingSecond + kFabSize + 16,
					),
					sliver: SliverList(
						delegate: SliverChildListDelegate.fixed([
							for (final settingsCategory in settingsCategories.entries)
								...[
									ListTile(
										title: Text(settingsCategory.key),
										leading: Icon(settingsCategory.value.key),
										trailing: const Icon(Boxicons.bxs_chevron_right),
										onTap: () => _pushPageRoute(context, settingsCategory.value.value),
									),
									if (settingsCategory != settingsCategories.entries.last)
										const SizedBox(height: kPaddingSecond),
								],
						]),
					),
				)
			],
		),
	);

	void _pushPageRoute(BuildContext context, Widget page) => Navigator.of(context).push(
		MaterialPageRoute(builder: (context) => page),
	);
}

class _SettingsSliverHeader extends ConsumerWidget {

	const _SettingsSliverHeader();

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final theme = Theme.of(context);
		final screenHeight = MediaQuery.of(context).size.height;
		return SliverPadding(
			padding: const EdgeInsets.only(
				top: kPaddingSecond,
				left: kPaddingSecond,
				right: kPaddingSecond,
			),
			sliver: SliverAppBar(
				automaticallyImplyLeading: false,
				pinned: true,
				stretch: true,
				floating: false,
				forceElevated: ref.watch(_scrollOffsetProvider) >= kTopBarHeight,
				toolbarHeight: kTopBarHeight,
				collapsedHeight: kTopBarHeight,
				expandedHeight: screenHeight * 0.2,
				backgroundColor: Color.lerp(
					theme.colorScheme.background,
					theme.colorScheme.surface,
					ref.watch(_scrollOffsetProvider).clamp(0, kTopBarHeight) / kTopBarHeight,
				),
				flexibleSpace: FlexibleSpaceBar(
					expandedTitleScale: screenHeight * 0.2 / kTopBarHeight,
					centerTitle: true,
					title: FittedBox(
						child: Text(
							"settings",
							style: theme.textTheme.titleLarge,
						).tr(),
					),
				),
			),
		);
	}
}

// TODO: custom form widgets for all categories & types
// TODO: global reset button
// TODO: per category reset button
// TODO: display default value label?
// TODO: theme not in appearance? rework categories
class _SettingsCategoryPage extends StatelessWidget {
	
	final String title;
	final void Function()? onExit;
	final void Function()? onReset;
	final List<Widget> children;

	const _SettingsCategoryPage({
		required this.title,
		this.onExit,
		this.onReset,
		required this.children,
	});

	@override
	Widget build(BuildContext context) => GenericRoute(
		title: title,
		trailing: onReset != null
			? IconButton(
				icon: const Icon(Boxicons.bx_reset),
				// TODO: confirm alert dialog before calling onReset
				onPressed: onReset,
			)
			: null,
		onExitTap: (context) async {
			onExit?.call();
			return true;
		},
		body: ListView(
			padding: const EdgeInsets.only(
				top: kTopBarHeight + kPaddingSecond * 2,
				left: kPaddingMain,
				right: kPaddingMain,
				bottom: kPaddingSecond + kFabSize + 16,
			),
			children: children,
		),
	);
}

class _SettingsThemePage extends ConsumerWidget {

	final themeModeText = {
		ThemeMode.system: "system".tr(),
		ThemeMode.dark: "dark".tr(),
		ThemeMode.light: "light".tr(),
	};

	_SettingsThemePage();

	@override
	Widget build(BuildContext context, WidgetRef ref) => _SettingsCategoryPage(
		title: "theme".tr(),
		onExit: () {},
		onReset: () {},
		children: [
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
		],
	);
}

class _SettingsLocalePage extends ConsumerWidget {

	const _SettingsLocalePage();

	@override
	Widget build(BuildContext context, WidgetRef ref) => _SettingsCategoryPage(
		title: "locale".tr(),
		onExit: () {},
		onReset: () {},
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
	);
}

// TODO: sliders value display
class _SettingsAppearancePage extends ConsumerWidget {

	final navLabelsText = {
		NavLabelsMode.all: "always-active".tr(),
		NavLabelsMode.disabled: "never-active".tr(),
		NavLabelsMode.onlySelected: "only-on-selected".tr(),
	};

	_SettingsAppearancePage();

	@override
	Widget build(BuildContext context, WidgetRef ref) => _SettingsCategoryPage(
		title: "appearance".tr(),
		onExit: () {},
		onReset: () {},
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

class _SettingsAdvancedPage extends ConsumerWidget {

	final pagesText = [
		"home".tr(),
		"library".tr(),
		"search".tr(),
		"more".tr(),
	];

	_SettingsAdvancedPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) => _SettingsCategoryPage(
		title: "advanced".tr(),
		onExit: () {},
		onReset: () {},
		children: [
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

// TODO: app update system
class _SettingsUpdatePage extends ConsumerWidget {

	const _SettingsUpdatePage();

	@override
	Widget build(BuildContext context, WidgetRef ref) => _SettingsCategoryPage(
		title: "update".tr(),
		onExit: () {},
		children: const [],
	);
}

// TODO: fill about page (app version, github link, license, nekosama link, flutter icon, ...)
class _SettingsAboutPage extends ConsumerWidget {

	const _SettingsAboutPage();

	@override
	Widget build(BuildContext context, WidgetRef ref) => _SettingsCategoryPage(
		title: "about".tr(),
		onExit: () {},
		children: const [],
	);
}
