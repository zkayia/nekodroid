
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/widgets/settings_sliver_title_route.dart';


// TODO: fill about page (app version, github link, license, nekosama link, flutter icon, ...)
class SettingsAboutRoute extends ConsumerWidget {

  const SettingsAboutRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SettingsSliverTitleRoute(
    title: context.tr.settingsAbout,
    children: const [],
  );
}
