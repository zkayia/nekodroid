import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:nekodroid/features/settings/logic/library_lists_config.dart';

class LibraryListCreateDialog extends ConsumerStatefulWidget {
  const LibraryListCreateDialog({super.key});

  @override
  ConsumerState<LibraryListCreateDialog> createState() => _LibraryListCreateDialogState();
}

class _LibraryListCreateDialogState extends ConsumerState<LibraryListCreateDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text("Créer une liste"),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: "Nom",
            errorText: _error,
            border: const OutlineInputBorder(borderRadius: kBorderRadCirc),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          onChanged: (value) => setState(() => _error = _validator(value.trim())),
          onSubmitted: (value) {
            final text = value.trim();
            final error = _validator(text);
            setState(() => _error = error);
            if (error == null) {
              context.nav.pop(text);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: context.nav.pop,
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              final text = _controller.text.trim();
              final error = _validator(text);
              setState(() => _error = error);
              if (error == null) {
                context.nav.pop(text);
              }
            },
            child: const Text("Ok"),
          ),
        ],
      );

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Nom invalide";
    }
    final lists = ref.read(libraryListsConfigProvider).valueOrNull;
    if (lists?.any((e) => e.name == value) ?? false) {
      return "Nom déjà pris";
    }
    return null;
  }
}
