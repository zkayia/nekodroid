
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants/nav_labels_mode.dart';
import 'package:nekodroid/constants/searchdb_status.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/searchdb_status.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/models/nav_bar_item.dart';
import 'package:nekodroid/routes/base/pages/home.dart';
import 'package:nekodroid/routes/base/pages/library.dart';
import 'package:nekodroid/routes/base/pages/more.dart';
import 'package:nekodroid/routes/base/pages/search.dart';
import 'package:nekodroid/routes/base/providers/nav_index.dart';
import 'package:nekodroid/routes/base/widgets/nav_bar.dart';


class BaseRoute extends ConsumerWidget {

  const BaseRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SafeArea(
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: ref.watch(navIndexProv),
        sizing: StackFit.expand,
        children: const [
          HomePage(),
          LibraryPage(),
          SearchPage(),
          MorePage(),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: NavBar(
        items: [
          NavBarItem(
            icon: Boxicons.bx_home_alt,
            label: context.tr.home,
          ),
          NavBarItem(
            icon: Boxicons.bx_library,
            label: context.tr.library,
          ),
          NavBarItem(
            icon: Boxicons.bx_search,
            label: context.tr.search,
          ),
          NavBarItem(
            icon: Boxicons.bx_dots_horizontal_rounded,
            label: context.tr.more,
          ),
        ],
        currentIndex: ref.watch(navIndexProv),
        onTap: (index) {
          ref.read(navIndexProv.notifier).update((state) => index);
          if (
            index == 2
            && ref.read(settingsProv).search.autoOpenBar
            && ref.read(searchdbStatusProv) == SearchdbStatus.ready
          ) {
            Navigator.of(context).pushNamed("/base/search");
          }
        },
        showSelectedLabels: ref.watch(
          settingsProv.select((v) => v.general.navLabelsMode),
        ) != NavLabelsMode.disabled,
        showUnselectedLabels:
          ref.watch(settingsProv.select((v) => v.general.navLabelsMode))
            != NavLabelsMode.disabled
          && ref.watch(settingsProv.select((v) => v.general.navLabelsMode))
            == NavLabelsMode.all,
      ),
    ),
  );
}
