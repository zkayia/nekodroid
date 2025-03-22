import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:nekodroid/core/extensions/text_style.dart';
import 'package:nekodroid/core/widgets/labelled_icon.dart';
import 'package:nekodroid/core/widgets/sliver_scaffold.dart';
import 'package:nekodroid/features/settings/logic/library_lists_config.dart';
import 'package:nekodroid/features/settings/widgets/library_list_create_dialog.dart';

class SettingsLibraryListsScreen extends ConsumerStatefulWidget {
  const SettingsLibraryListsScreen({super.key});

  @override
  ConsumerState<SettingsLibraryListsScreen> createState() => _SettingsLibraryListsScreenState();
}

class _SettingsLibraryListsScreenState extends ConsumerState<SettingsLibraryListsScreen> {
  var _isDirty = false;

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: !_isDirty,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            final result = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  "Quitter sans sauvegarder ?",
                  style: context.th.textTheme.titleMedium.bold(),
                ),
                actions: [
                  TextButton(onPressed: () => context.nav.pop(true), child: const Text("Quitter")),
                  ElevatedButton(onPressed: () => context.nav.pop(false), child: const Text("Rester")),
                ],
              ),
            );
            if ((result ?? false) && context.mounted) {
              context.pop();
            }
          }
        },
        child: Center(
          child: ref.watch(libraryListsConfigProvider).when(
                loading: CircularProgressIndicator.new,
                error: (error, stackTrace) => Text("$error\n$stackTrace"),
                data: (lists) => SliverScaffold(
                  floatingActionButton: _isDirty
                      ? FloatingActionButton(
                          onPressed: () async {
                            ref.read(libraryListsConfigProvider.notifier).saveToDb();
                            setState(() => _isDirty = false);
                          },
                          child: const Icon(Symbols.check_rounded),
                        )
                      : null,
                  title: const Text("Bibliothèque"),
                  actions: [
                    IconButton(
                      onPressed: () async {
                        final result = await showDialog<String>(
                          context: context,
                          builder: (context) => const LibraryListCreateDialog(),
                        );
                        if (result != null) {
                          setState(() => _isDirty = true);
                          ref.read(libraryListsConfigProvider.notifier).addList(result);
                        }
                      },
                      icon: const Icon(Symbols.add_rounded),
                    ),
                    if (lists.any((e) => e.selected))
                      IconButton(
                        onPressed: () {
                          setState(() => _isDirty = true);
                          ref.read(libraryListsConfigProvider.notifier).deleteSelected();
                        },
                        icon: const Icon(Symbols.delete_rounded),
                      ),
                  ],
                  body: lists.isEmpty
                      ? const LabelledIcon.vertical(
                          label: "Aucune liste",
                          icon: Icon(Symbols.playlist_remove_rounded),
                        )
                      : ReorderableListView.builder(
                          padding: const EdgeInsets.all(kPadding),
                          onReorder: (oldIndex, newIndex) {
                            setState(() => _isDirty = true);
                            ref.read(libraryListsConfigProvider.notifier).reorder(oldIndex, newIndex);
                          },
                          itemCount: lists.length,
                          itemBuilder: (context, index) {
                            final list = lists.elementAt(index);
                            return CheckboxListTile(
                              key: ValueKey(list.name),
                              title: Text(list.name),
                              secondary: const Icon(Symbols.drag_indicator_rounded),
                              value: list.selected,
                              onChanged: (value) =>
                                  ref.read(libraryListsConfigProvider.notifier).setSelected(index, value ?? false),
                            );
                          },
                        ),
                ),
              ),
        ),
      );
}
