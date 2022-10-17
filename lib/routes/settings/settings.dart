
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/constants/widget_title_mixin.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/settings/pages/about.dart';
import 'package:nekodroid/routes/settings/pages/anime.dart';
import 'package:nekodroid/routes/settings/pages/general.dart';
import 'package:nekodroid/routes/settings/pages/home.dart';
import 'package:nekodroid/routes/settings/pages/library.dart';
import 'package:nekodroid/routes/settings/pages/player.dart';
import 'package:nekodroid/routes/settings/pages/search.dart';
import 'package:nekodroid/routes/settings/widgets/settings_sliver_title_route.dart';


class SettingsRoute extends ConsumerWidget {

  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<IconData, WidgetTitleMixin> settingsCategories = {
      Boxicons.bxs_cog: SettingsGeneralPage(context.tr.settingsGeneral),
      Boxicons.bxs_home_alt_2: SettingsHomePage(context.tr.home),
      Boxicons.bx_library: SettingsLibraryPage(context.tr.library),
      Boxicons.bxs_search: SettingsSearchPage(context.tr.search),
      Boxicons.bxs_tv: SettingsAnimePage(context.tr.anime),
      Boxicons.bx_play: SettingsPlayerPage(context.tr.player),
      Boxicons.bxs_info_circle: SettingsAboutPage(context.tr.settingsAbout),
    };
    return SettingsSliverTitleRoute(
      title: context.tr.settings,
      verticalPadding: kPaddingSecond,
      onExitTap: (_) async {
        await ref.read(settingsProv.notifier).saveToHive();
        return true;
      },
      children: [
        ...settingsCategories.entries.map(
          (e) => ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: kPaddingSecond,
            ),
            title: Text(e.value.title),
            leading: Icon(e.key),
            trailing: const Icon(Boxicons.bxs_chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => e.value),
            ),
          ),
        ),
      ],
    );
  }
}
