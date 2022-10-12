
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/provider/settings.dart';


class LibraryAppBar extends ConsumerWidget {

  const LibraryAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Card(
    margin: const EdgeInsets.all(kPaddingSecond),
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.maxFinite,
      ),
      child: TabBar(
        isScrollable:
          ref.watch(settingsProvider.select((v) => v.library.enableTabbarScrolling)),
        physics: kDefaultScrollPhysics,
        splashBorderRadius: BorderRadius.circular(kBorderRadMain),
        tabs: [
          if (ref.watch(settingsProvider.select((v) => v.library.enableHistory)))
            const Tab(
              height: kTopBarHeight - kTabbarIndicatorSize,
              icon: Icon(Boxicons.bx_history),
            ),
          if (ref.watch(settingsProvider.select((v) => v.library.enableFavorites)))
            const Tab(
              height: kTopBarHeight - kTabbarIndicatorSize,
              icon: Icon(Boxicons.bxs_heart),
            ),
          ...?ref.watch(settingsProvider.select((v) => v.library.lists))?.map(
            (e) => Tab(
              height: kTopBarHeight - kTabbarIndicatorSize,
              text: e.label,
              icon: e.icon == null ? null : Icon(e.icon),
            ),
          )
        ],
      ),
    ),
  );
}
