import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:nekodroid/core/extensions/text_style.dart';
import 'package:nekodroid/core/widgets/labelled_icon.dart';
import 'package:nekodroid/features/anime/logic/lists_dialog.dart';

class ListsDialog extends ConsumerStatefulWidget {
  final Uri url;

  const ListsDialog({
    required this.url,
    super.key,
  });

  @override
  ConsumerState<ListsDialog> createState() => _ListsDialogState();
}

class _ListsDialogState extends ConsumerState<ListsDialog> {
  Map<LibraryList, bool>? _selection;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: ListView(
          padding: EdgeInsets.only(
            right: kPadding,
            left: kPadding,
            bottom: kPadding + context.mq.padding.bottom,
          ),
          shrinkWrap: true,
          children: ref.watch(listsDialogProvider(widget.url)).when(
                loading: () => const [Center(child: CircularProgressIndicator())],
                error: (error, stackTrace) => [
                  Center(
                    child: LabelledIcon.vertical(
                      label: "Impossible de charger les listes",
                      icon: const Icon(Symbols.error_rounded),
                      action: ElevatedButton(
                        onPressed: Navigator.of(context).pop,
                        child: const Text("Fermer"),
                      ),
                      mainAxisSize: MainAxisSize.min,
                    ),
                  ),
                ],
                data: (data) {
                  if (_selection == null) {
                    setState(
                      () => _selection = {for (final list in data.libraryLists) list: data.libraryListsAnimeIsIn.contains(list)},
                    );
                  }
                  return data.libraryLists.isEmpty
                      ? [
                          LabelledIcon.vertical(
                            label: "Aucune liste configurée",
                            icon: const Icon(Symbols.playlist_remove_rounded),
                            action: ElevatedButton(
                              onPressed: Navigator.of(context).pop,
                              child: const Text("Fermer"),
                            ),
                            mainAxisSize: MainAxisSize.min,
                          ),
                        ]
                      : [
                          Text(
                            "Bibliothèque",
                            textAlign: TextAlign.center,
                            style: context.th.textTheme.titleLarge.bold(),
                          ),
                          for (final list in data.libraryLists)
                            CheckboxListTile(
                              title: Text(list.name),
                              value: _selection![list],
                              onChanged: (value) => setState(() => _selection![list] = value ?? false),
                            ),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: context.nav.pop,
                                  child: const Text("Annuler"),
                                ),
                              ),
                              const SizedBox(width: kPadding),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => context.nav.pop(_selection),
                                  child: const Text("Ok"),
                                ),
                              ),
                            ],
                          ),
                        ];
                },
              ),
        ),
      );
}
