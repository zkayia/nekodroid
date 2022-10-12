
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/widgets/generic_route.dart';


class SettingsLibraryListsPage extends ConsumerWidget {

  const SettingsLibraryListsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => GenericRoute(
    body: ListView(
      children: const [
        Text("list config")
      ],
    ),
  );
}
