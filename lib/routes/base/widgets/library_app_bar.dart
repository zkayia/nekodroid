
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/provider/lists.dart';


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
          ...ref.watch(listsProvider).when(
            error: (error, _) => const [
              Tab(
                height: kTopBarHeight - kTabbarIndicatorSize,
                icon: Icon(Boxicons.bx_error_circle),
              ),
            ],
            loading: () => [
              Tab(
                height: kTopBarHeight - kTabbarIndicatorSize,
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(
                    Size.square(Theme.of(context).iconTheme.size ?? 24),
                  ),
                  child: const CircularProgressIndicator(),
                ),
              ),
            ],
            data: (data) => data.isEmpty
              ? const [
                Tab(
                  height: kTopBarHeight - kTabbarIndicatorSize,
                  icon: Icon(Boxicons.bx_plus),
                )
              ]
              : data.map(
                (e) => Tab(
                  height: kTopBarHeight - kTabbarIndicatorSize,
                  text: e.name,
                ),
              ),
          ),
        ],
      ),
    ),
  );
}
