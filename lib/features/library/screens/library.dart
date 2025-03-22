import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/core/widgets/labelled_icon.dart';
import 'package:nekodroid/core/widgets/sliver_scaffold.dart';
import 'package:nekodroid/features/library/logic/animes_in_list.dart';
import 'package:nekodroid/features/library/logic/library_lists.dart';
import 'package:nekodroid/features/library/widgets/library_tile.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Center(
        child: ref.watch(libraryListsProvider).when(
              loading: CircularProgressIndicator.new,
              error: (error, stackTrace) => Text(error.toString()),
              data: (lists) {
                final appbar = AppBar(
                  title: const Text("Bibliothèque"),
                  actions: [
                    IconButton(
                      onPressed: () => context.push("/history"),
                      icon: const Icon(Symbols.history_rounded),
                    ),
                  ],
                );
                if (lists.isEmpty) {
                  return Scaffold(
                    appBar: appbar,
                    body: Center(
                      child: LabelledIcon.vertical(
                        label: "Aucune liste",
                        icon: const Icon(Symbols.playlist_remove_rounded),
                        action: TextButton(
                          onPressed: () => context.push("/settings/library/lists"),
                          child: const Text("Ajouter"),
                        ),
                      ),
                    ),
                  );
                }
                final tabbar = TabBar(
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  splashBorderRadius: kBorderRadCirc,
                  tabs: [for (final tab in lists) Tab(text: tab.name)],
                );
                return DefaultTabController(
                  length: lists.length,
                  child: SliverScaffold(
                    noSafeArea: true,
                    title: appbar.title,
                    actions: appbar.actions,
                    bottom: PreferredSize(
                      preferredSize: tabbar.preferredSize,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: tabbar,
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        for (final tab in lists)
                          Center(
                            child: RefreshIndicator(
                              onRefresh: () => Future.wait([]),
                              child: ref.watch(animesInListProvider(tab.name)).when(
                                    loading: CircularProgressIndicator.new,
                                    error: (error, stackTrace) => Text(error.toString()),
                                    data: (animes) {
                                      if (animes.isEmpty) {
                                        return LabelledIcon.vertical(
                                          label: "Aucun anime",
                                          icon: const Icon(Symbols.playlist_remove_rounded),
                                          action: TextButton(
                                            onPressed: () => context.go("/explore"),
                                            child: const Text("Explorer"),
                                          ),
                                        );
                                      }
                                      return OrientationBuilder(
                                        builder: (context, orientation) => GridView.builder(
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: orientation == Orientation.portrait ? 2 : 6,
                                            childAspectRatio: 5 / 7,
                                            crossAxisSpacing: kPadding,
                                            mainAxisSpacing: kPadding,
                                          ),
                                          padding: const EdgeInsets.all(kPadding),
                                          itemCount: animes.length,
                                          itemBuilder: (context, index) => LibraryTile(animes.elementAt(index)),
                                        ),
                                      );
                                    },
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      );
}
