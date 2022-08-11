
import 'package:android_intent_plus/android_intent.dart';
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/app_localizations.dart';
import 'package:nekodroid/routes/base/widgets/list_tile_icon.dart';
import 'package:nekodroid/routes/base/widgets/private_browsing_switch.dart';
import 'package:nekodroid/widgets/single_line_text.dart';
import 'package:package_info_plus/package_info_plus.dart';


class MorePage extends StatelessWidget {

	const MorePage({super.key});

	@override
	Widget build(BuildContext context) => Padding(
		padding: const EdgeInsets.only(
			top: kPaddingSecond,
			left: kPaddingMain,
			right: kPaddingMain,
			bottom: kPaddingSecond * 2 + kBottomBarHeight,
		),
		child: Column(
			children: [
				Expanded(
					child: Center(
						child: Padding(
							padding: const EdgeInsets.all(kPaddingMain),
							child: SvgPicture.asset(
								"assets/images/nekodroid_logo_${
									Theme.of(context).brightness == Brightness.dark
										? "regular"
										: "black"
								}.svg",
								width: MediaQuery.of(context).size.width / 4,
							),
						),
					),
				),
				const PrivateBrowsingSwitch(),
				const Divider(),
				ListTile(
					enabled: false, //TODO: make /stats
					leading: const ListTileIcon(Boxicons.bx_bar_chart),
					title: Text(context.tr.statistics),
					onTap: () {}, //TODO: goto /stats
				),
				ListTile(
					enabled: false, //TODO: make /backup
					leading: const ListTileIcon(Boxicons.bxs_save),
					title: Text(context.tr.backupRestore),
					onTap: () {}, //TODO: goto /backup
				),
				ListTile(
					leading: const ListTileIcon(Boxicons.bxs_cog),
					title: Text(context.tr.settings),
					onTap: () => Navigator.of(context).pushNamed("/settings"),
				),
				Center(
					child: IconButton(
						icon: const Icon(Boxicons.bxl_github),
						onPressed: () => AndroidIntent(
							action: "action_view",
							data: kAppRepoUrl.toString(),
						).launch(),
					),
				),
				Center(
					child: FutureBuilder(
						future: PackageInfo.fromPlatform(),
						builder: (context, AsyncSnapshot<PackageInfo> snap) => SingleLineText.secondary(
							"${snap.data?.appName ?? "..."} ${snap.data?.version ?? ""}".trim(),
						),
					),
				),
			],
		),
	);
}
