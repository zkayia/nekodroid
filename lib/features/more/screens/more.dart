import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:nekodroid/core/utils/network.dart';
import 'package:nekodroid/features/dev_tools/logic/display_dev_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/features/more/widgets/dev_tools_toggle.dart';
import 'package:nekodroid/features/more/widgets/private_browsing_switch.dart';
import 'package:nekodroid/gen/assets.gen.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = [
      Expanded(
        child: Center(
          child: DevToolsToggle(
            child: Image.asset(
              Assets.img.nekodroidLogoDark.path,
              width: context.mq.size.width / 3,
            ),
          ),
        ),
      ),
      const PrivateBrowsingSwitch(),
      const Divider(),
      // ListTile(
      //   enabled: false,
      //   onTap: () {},
      //   leading: const Icon(Symbols.bar_chart_rounded),
      //   title: const Text("Statistiques"),
      // ),
      ListTile(
        onTap: () => context.push("/backup"),
        leading: const Icon(Symbols.save_rounded),
        title: const Text("Sauvegarde"),
      ),
      ListTile(
        onTap: () => context.push("/settings"),
        leading: const Icon(Symbols.settings_rounded),
        title: const Text("Paramètres"),
      ),
      if (ref.watch(displayDevToolsProvider))
        ListTile(
          onTap: () => context.push("/dev_tools"),
          leading: const Icon(Symbols.bug_report_rounded),
          title: const Text("Dev tools"),
        ),
      Center(
        child: IconButton(
          icon: Image.asset(
            "assets/img/github-logo-48.png",
            height: 24,
            width: 24,
          ),
          onPressed: () => NetworkUtils.launchUrl(kAppRepoUrl, context),
        ),
      ),
      Center(
        child: FutureBuilder(
          future: PackageInfo.fromPlatform(),
          builder: (context, AsyncSnapshot<PackageInfo> snap) => Text(
            "${snap.data?.appName ?? "..."} ${snap.data?.version ?? ""}".trim(),
            maxLines: 1,
            style: context.th.textTheme.labelMedium,
          ),
        ),
      ),
    ];
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) => orientation == Orientation.portrait
            ? Padding(
                padding: const EdgeInsets.all(kPadding),
                child: Column(children: children),
              )
            : ListView(
                padding: const EdgeInsets.all(kPadding),
                children: children,
              ),
      ),
    );
  }
}
