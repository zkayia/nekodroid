
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/sliver_title_scrollview_route.dart';


class SettingsSliverTitleRoute extends StatelessWidget {

  final String title;
  final double verticalPadding;
  final double horizontalPadding;
  final List<Widget> children;
  final Future<bool> Function(BuildContext context)? onExitTap;
  
  const SettingsSliverTitleRoute({
    required this.title,
    required this.children,
    this.verticalPadding=kPaddingMain,
    this.horizontalPadding=kPaddingSecond,
    this.onExitTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SliverTitleScrollviewRoute(
    title: title,
    onExitTap: onExitTap,
    horizontalPadding: horizontalPadding,
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => index.isEven
          ? children.elementAt(index ~/ 2)
          : SizedBox(height: verticalPadding),
        childCount: children.length * 2 - 1,
        semanticIndexCallback: (_, index) => index.isEven
          ? index ~/ 2
          : null,
      ),
    ),
  );
}
