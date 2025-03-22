import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/core/widgets/labelled_icon.dart';
import 'package:nekodroid/core/widgets/sliver_scaffold.dart';
import 'package:nekodroid/features/history/logic/history.dart';
import 'package:nekodroid/features/history/widgets/history_tile.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverScaffold(
        title: const Text("Historique"),
        body: Scrollbar(
          child: RefreshIndicator(
            onRefresh: () => ref.refresh(historyProvider.future),
            child: Center(
              child: ref.watch(historyProvider).when(
                    loading: CircularProgressIndicator.new,
                    error: (error, stackTrace) => Text(error.toString()),
                    data: (history) {
                      if (history.isEmpty) {
                        return LabelledIcon.vertical(
                          label: "Aucun historique",
                          icon: const Icon(Symbols.playlist_remove_rounded),
                          action: TextButton(
                            onPressed: () => context.go("/explore"),
                            child: const Text("Explorer"),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(kPadding),
                        itemCount: history.length,
                        itemBuilder: (context, index) => HistoryTile(history.elementAt(index)),
                      );
                    },
                  ),
            ),
          ),
        ),
      );
}
