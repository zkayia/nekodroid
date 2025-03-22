import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:nekodroid/core/extensions/text_style.dart';
import 'package:nekodroid/core/widgets/sliver_scaffold.dart';
import 'package:nekodroid/features/backup/logic/backup.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  var _onConflictUpdate = true;

  @override
  Widget build(BuildContext context) {
    final isIdle = ref.watch(
      backupProvider.select((v) => ![const ExportingBackupState(), const ImportingBackupState()].contains(v)),
    );
    return SliverScaffold(
      title: const Text("Sauvegarde"),
      body: ListView(
        padding: const EdgeInsets.all(kPadding),
        children: [
          ListTile(
            enabled: isIdle,
            onTap: () => ref
                .read(backupProvider.notifier)
                .export()
                .onError((error, stackTrace) => Fluttertoast.showToast(msg: "Echec de la sauvegarde"))
                .then((_) => Fluttertoast.showToast(msg: "Sauvegarde crée")),
            leading: const Icon(Symbols.upload_rounded),
            trailing: ref.watch(
              backupProvider.select(
                (v) => switch (v) {
                  final ExportingBackupState _ => const CircularProgressIndicator(),
                  final ExportErroredBackupState _ => const Icon(Symbols.error_rounded),
                  _ => null,
                },
              ),
            ),
            title: const Text("Créer une sauvegarde"),
          ),
          const Divider(),
          ListTile(
            enabled: isIdle,
            onTap: () => ref
                .read(backupProvider.notifier)
                .import(onConflictUpdate: _onConflictUpdate)
                .onError((error, stackTrace) => Fluttertoast.showToast(msg: "Echec de la restauration"))
                .then((_) => Fluttertoast.showToast(msg: "Restauration réussie")),
            leading: const Icon(Symbols.download_rounded),
            trailing: ref.watch(
              backupProvider.select(
                (v) => switch (v) {
                  final ImportingBackupState _ => const CircularProgressIndicator(),
                  final ImportErroredBackupState _ => const Icon(Symbols.error_rounded),
                  _ => null,
                },
              ),
            ),
            title: const Text("Restaurer une sauvegarde"),
          ),
          CheckboxListTile(
            value: _onConflictUpdate,
            onChanged: (value) {
              if (value != null) {
                setState(() => _onConflictUpdate = value);
              }
            },
            secondary: const SizedBox(),
            title: Text(
              "Mettre à jour en cas de conflit",
              style: context.th.textTheme.labelLarge.bold(),
            ),
          ),
        ],
      ),
    );
  }
}
