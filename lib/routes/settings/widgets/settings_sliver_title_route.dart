
import 'package:flutter/material.dart';
import 'package:nekodroid/widgets/sliver_title_scrollview_route.dart';


class SettingsSliverTitleRoute extends StatelessWidget {

  final String title;
  final List<Widget> children;
  final Future<bool> Function(BuildContext context)? onExitTap;
  
  const SettingsSliverTitleRoute({
    required this.title,
    required this.children,
    this.onExitTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SliverTitleScrollviewRoute(
    title: title,
    onExitTap: onExitTap,
    sliver: SliverList(
      delegate: SliverChildListDelegate.fixed(children),
    ),
  );
}
