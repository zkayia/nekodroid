
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/widgets/generic_route.dart';
import 'package:nekodroid/widgets/sliver_title_scrollview.dart';


class SettingsRoute extends ConsumerWidget {

  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<IconData, MapEntry<String, String>> settingsCategories = {
      Boxicons.bxs_cog: MapEntry(
        "/settings/general",
        context.tr.settingsGeneral,
      ),
      Boxicons.bxs_home_alt_2: MapEntry(
        "/settings/home",
        context.tr.home,
      ),
      Boxicons.bx_library: MapEntry(
        "/settings/library",
        context.tr.library,
      ),
      Boxicons.bxs_search: MapEntry(
        "/settings/search",
        context.tr.search,
      ),
      Boxicons.bxs_tv: MapEntry(
        "/settings/anime",
        context.tr.anime,
      ),
      Boxicons.bx_play: MapEntry(
        "/settings/player",
        context.tr.player,
      ),
      Boxicons.bxs_info_circle: MapEntry(
        "/settings/about",
        context.tr.settingsAbout,
      ),
    };
    return GenericRoute(
      onExitTap: (_) async {
        await ref.read(settingsProv.notifier).saveToHive();
        return true;
      },
      body: SliverTitleScrollview.list(
        title: context.tr.settings,
        verticalPadding: kPaddingSecond,
        horizontalPadding: kPaddingMain,
        children: [
          ...settingsCategories.entries.map(
            (e) => ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: kPaddingSecond,
              ),
              title: Text(e.value.value),
              leading: Icon(e.key),
              trailing: const Icon(Boxicons.bxs_chevron_right),
              onTap: () => Navigator.of(context).pushNamed(e.value.key),
            ),
          ),
        ],
      ),
    );
  }
}
