import 'package:flutter/material.dart';

class SliverScaffold extends StatelessWidget {
  final bool noSafeArea;
  final Widget? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Widget? floatingActionButton;
  final Widget body;

  const SliverScaffold({
    this.noSafeArea = false,
    this.title,
    this.actions,
    this.bottom,
    this.floatingActionButton,
    required this.body,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      floatingActionButton: floatingActionButton,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            primary: false,
            // TODO: maybe? (needs to fill statusbar)
            // backgroundColor: innerBoxIsScrolled ? context.th.colorScheme.surface : null,
            pinned: true,
            floating: true,
            snap: true,
            forceElevated: innerBoxIsScrolled,
            title: title,
            actions: actions,
            bottom: bottom ??
                const PreferredSize(
                  preferredSize: Size.zero,
                  child: SizedBox(),
                ),
          ),
        ],
        body: body,
      ),
    );
    return noSafeArea
        ? scaffold
        : SafeArea(
            top: false,
            bottom: false,
            child: scaffold,
          );
  }
}
