
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/base/widgets/library_app_bar.dart';
import 'package:nekodroid/routes/base/widgets/library_tabview.dart';


class LibraryPage extends ConsumerWidget {

  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => DefaultTabController(
    length: ref.watch(
      settingsProvider.select(
        (v) =>
          (v.library.enableHistory ? 1 : 0)
          + (v.library.enableFavorites ? 1 : 0)
          + (v.library.lists?.length ?? 0),
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
