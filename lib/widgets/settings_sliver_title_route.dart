
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/sliver_title_scrollview_route.dart';


class SettingsSliverTitleRoute extends StatelessWidget {

  final String title;
  final double verticalPadding;
  final List<Widget> children;
  final Future<bool> Function(BuildContext context)? onExitTap;
  
  const SettingsSliverTitleRoute({
    required this.title,
    required this.children,
    this.verticalPadding=kPaddingMain,
    this.onExitTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SliverTitleScrollviewRoute(
    title: title,
    onExitTap: onExitTap,
    sliver: SliverList(
      delegate: SliverChildListDelegate.fixed([
        for (int i = 0 ; i < children.length * 2 - 1; i++)
          i.isEven
            ? children.elementAt(i ~/ 2)
            : SizedBox(height: verticalPadding),
      ]),
    ),
  );
}
