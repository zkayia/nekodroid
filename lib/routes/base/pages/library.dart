
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/extensions/bool.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/provider/lists.dart';
import 'package:nekodroid/routes/base/widgets/library_app_bar.dart';
import 'package:nekodroid/routes/base/widgets/library_tabview.dart';


class LibraryPage extends ConsumerWidget {

  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int tabsCount = ref.watch(
      settingsProvider.select(
        (v) => v.library.enableHistory.toInt() + v.library.enableFavorites.toInt(),
      ),
    ) + ref.watch(listsProvider).when(
      error: (_, __) => 1,
      loading: () => 1,
      data: (data) => data.isEmpty ? 1 : data.length,
    );
    return DefaultTabController(
      length: tabsCount,
      initialIndex: ref.watch(
        settingsProvider.select(
          (v) => v.library.defaultTab
            + 2
            - v.library.enableHistory.toInverseInt()
            - v.library.enableFavorites.toInverseInt()
            .clamp(0, tabsCount - 1),
        ),
      ),
      child: Stack(
        children: const [
          LibraryTabview(),
          Align(
            alignment: Alignment.topCenter,
            child: LibraryAppBar(),
          ),
        ],
      ),
    );
  }
}
