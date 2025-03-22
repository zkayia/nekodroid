import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/providers/db_sql.dart';
import 'package:nekodroid/core/providers/error.dart';
import 'package:nekodroid/core/widgets/sliver_scaffold.dart';
import 'package:nekodroid/features/dev_tools/widgets/dev_tool.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:drift_db_viewer/drift_db_viewer.dart';

class DevToolsScreen extends ConsumerWidget {
  const DevToolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverScaffold(
        title: const Text("Dev tools"),
        body: ListView(
          padding: const EdgeInsets.all(kPadding),
          children: [
            if (kDebugMode)
              DevTool(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DriftDbViewer(ref.read(dbSqlProvider))),
                ),
                title: "Database inspector",
                trailing: const Icon(Symbols.chevron_right_rounded),
              ),
            DevTool(
              onTap: () => ref.read(errorProvider.notifier).checkForErrors(),
              title: "Run error check",
            ),
            DevTool.withValue(
              onTap: () => ref.read(errorProvider.notifier).toggleError(const NoNetworkError()),
              title: "Toggle network error",
              value: ref.watch(errorProvider).contains(const NoNetworkError()),
            ),
            DevTool.withValue(
              onTap: () => ref.read(errorProvider.notifier).toggleError(const CantAccessHostError()),
              title: "Toggle timetable access error",
              value: ref.watch(errorProvider).contains(const CantAccessHostError()),
            ),
          ],
        ),
      );
}
