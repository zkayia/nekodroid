
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants/widget_title_mixin.dart';
import 'package:nekodroid/routes/settings/widgets/settings_sliver_title_route.dart';


// TODO: fill about page (app version, github link, license, nekosama link, flutter icon, ...)
class SettingsAboutPage extends ConsumerWidget implements WidgetTitleMixin {

  @override
  final String title;

  const SettingsAboutPage(
    this.title,
    {
      super.key,
    }
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) => SettingsSliverTitleRoute(
    title: title,
    children: const [],
  );
}
