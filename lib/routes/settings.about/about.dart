
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/routes/settings.about/widgets/external_link_tile.dart';
import 'package:nekodroid/widgets/generic_route.dart';
import 'package:nekodroid/widgets/list_tile_icon.dart';
import 'package:nekodroid/widgets/sliver_title_scrollview.dart';


class SettingsAboutRoute extends ConsumerWidget {

  const SettingsAboutRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => GenericRoute(
    body: SliverTitleScrollview.list(
      title: context.tr.settingsAbout,
      children: [
        ExternalLinkTile(
          title: "NekoSama",
          link: Uri.https("neko-sama.fr"),
          logo: const ListTileIcon(Boxicons.bx_heart),
        ),
        ExternalLinkTile(
          title: "Source code",
          link: kAppRepoUrl,
          logo: const ListTileIcon(Boxicons.bxl_github),
        ),
        ExternalLinkTile(
          title: "Issue tracker",
          link: kAppIssuesUrl,
          logo: const ListTileIcon(Boxicons.bx_bug),
        ),
        ExternalLinkTile(
          title: "Changelog",
          link: kAppChangelogUrl,
          logo: const ListTileIcon(Boxicons.bxl_git),
        ),
        ExternalLinkTile(
          title: "License",
          link: kAppLicenseUrl,
          logo: const ListTileIcon(Boxicons.bx_book_bookmark),
        ),
        const Center(child: Text("Made with")),
        ExternalLinkTile(
          title: "Flutter",
          link: Uri.https("flutter.dev"),
          logo: const SizedBox(
            height: double.maxFinite,
            child: FlutterLogo(),
          ),
        ),
        ...kAppDependencies.map(
          (e) => ExternalLinkTile(
            title: e,
            link: Uri.https("pub.dev", "/packages/$e"),
          ),
        )
      ],
    ),
  );
}
