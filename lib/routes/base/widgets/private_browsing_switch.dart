
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/base/widgets/list_tile_icon.dart';


class PrivateBrowsingSwitch extends ConsumerWidget {

  const PrivateBrowsingSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
    leading: const ListTileIcon(Boxicons.bxs_mask),
    title: Text(context.tr.morePrivateBrowsing),
    subtitle: Text(context.tr.morePrivateBrowsingDescription),
    trailing: Switch(
      value: ref.watch(settingsProv.select((v) => v.session.privateBrowsingEnabled)),
      onChanged: (bool value) =>
        ref.read(settingsProv.notifier).privateBrowsingEnabled = value,
    ),
    onTap: () => ref.read(settingsProv.notifier).togglePrivateBrowsingEnabled(),
  );
}
