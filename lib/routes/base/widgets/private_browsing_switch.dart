
import 'package:boxicons/boxicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/base/widgets/list_tile_icon.dart';


class PrivateBrowsingSwitch extends ConsumerWidget {

	const PrivateBrowsingSwitch({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) => ListTile(
		// TODO: implement private browsing
		enabled: false,
		leading: const ListTileIcon(Boxicons.bx_low_vision),
		title: const Text("private-browsing").tr(),
		subtitle: const Text("private-browsing-desc").tr(),
		// trailing: Switch(
		// 	value: ref.watch(settingsProvider.select((value) => value.secrecyEnabled)),
		// 	onChanged: (bool value) =>
		// 		ref.read(settingsProvider.notifier).secrecyEnabled = value,
		// ),
		onTap: () => ref.read(settingsProvider.notifier).switchSecrecyEnabled(),
	);
}
