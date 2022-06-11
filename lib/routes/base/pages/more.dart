
import 'package:boxicons/boxicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/routes/base/widgets/list_tile_icon.dart';
import 'package:nekodroid/routes/base/widgets/private_browsing_switch.dart';
import 'package:nekodroid/widgets/single_line_text.dart';
import 'package:url_launcher/url_launcher.dart';


class MorePage extends StatelessWidget {

	const MorePage({Key? key}) : super(key: key);

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
					title: const Text("stats").tr(),
					onTap: () {}, //TODO: goto /stats
				),
				ListTile(
					enabled: false, //TODO: make /backup
					leading: const ListTileIcon(Boxicons.bx_save),
					title: const Text("backup-restore").tr(),
					onTap: () {}, //TODO: goto /backup
				),
				ListTile(
					leading: const ListTileIcon(Boxicons.bx_cog),
					title: const Text("settings").tr(),
					onTap: () => Navigator.of(context).pushNamed("/settings"),
				),
				Center(
					child: IconButton(
						icon: const Icon(Boxicons.bxl_github),
						onPressed: () async {
							if (await canLaunchUrl(kAppRepoUrl)) {
								await launchUrl(
									kAppRepoUrl,
									mode: LaunchMode.externalApplication,
								);
							}
						},
					),
				),
				Center(
					child: SingleLineText.secondary("${"app-title".tr()} $kAppVersion"),
				),
			],
		),
	);
}
