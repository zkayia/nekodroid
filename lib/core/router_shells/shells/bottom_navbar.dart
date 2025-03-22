import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:nekodroid/core/extensions/text_style.dart';
import 'package:nekodroid/core/router_shells/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/core/router_shells/widgets/nav_rail.dart';

class BottomNavbarShell extends ConsumerWidget {
  final int index;
  final Widget child;

  const BottomNavbarShell({
    required this.index,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => OrientationBuilder(
        builder: (context, orientation) => Scaffold(
          body: Theme(
            data: context.th.copyWith(
              appBarTheme: context.th.appBarTheme.copyWith(
                titleTextStyle: context.th.textTheme.displaySmall.bold(),
              ),
            ),
            child: orientation == Orientation.portrait
                ? child
                : Row(
                    children: [
                      NavRail(index: index),
                      Expanded(
                        child: child,
                      ),
                    ],
                  ),
          ),
          bottomNavigationBar: orientation == Orientation.portrait ? BottomNavbar(index: index) : null,
        ),
      );
}
