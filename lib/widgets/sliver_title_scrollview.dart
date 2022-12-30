
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';


class SliverTitleScrollview extends ConsumerWidget {

  final bool isList;
  final String title;
  final Widget? sliver;
  final List<Widget>? children;
  final bool hasFab;
  final double horizontalPadding;
  final double verticalPadding;
  final double listSeparatorSize;

  const SliverTitleScrollview({
    required this.title,
    required this.sliver,
    this.hasFab=true,
    this.horizontalPadding=kPaddingSecond,
    this.verticalPadding=kPaddingSecond,
    super.key,
  }) :
    isList = false,
    listSeparatorSize = 0,
    children = null;

  const SliverTitleScrollview.list({
    required this.title,
    required this.children,
    this.hasFab=true,
    this.horizontalPadding=kPaddingSecond,
    this.verticalPadding=kPaddingSecond,
    this.listSeparatorSize=kPaddingMain,
    super.key,
  }) :
    isList = true,
    sliver = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) => CustomScrollView(
    physics: kDefaultScrollPhysics,
    controller: ref.watch(_scrollControllerProvider(title)),
    shrinkWrap: true,
    slivers: [
      const SliverPersistentHeader(
        pinned: true,
        delegate: _VerticalPaddingPersistantHeaderDelegate(
          padding: kPaddingSecond,
        ),
      ),
      _SettingsSliverHeader(title),
      SliverPadding(
        padding: EdgeInsets.only(
          top: verticalPadding,
          left: horizontalPadding,
          right: horizontalPadding,
          bottom: hasFab
            ? verticalPadding + kFabSize + 16
            : verticalPadding,
        ),
        sliver: isList
          ? SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => index.isEven
                ? children!.elementAt(index ~/ 2)
                : SizedBox(height: listSeparatorSize),
              childCount: children!.length * 2 - 1,
              semanticIndexCallback: (_, index) => index.isEven
                ? index ~/ 2
                : null,
            ),
          )
          : sliver,
      ),
    ],
  );
}

final _scrollControllerProvider = Provider.autoDispose.family<ScrollController, String>(
  (ref, title) {
    final controller = ScrollController();
    controller.addListener(
      () => ref.watch(_scrollOffsetRatioProvider(title).notifier).update(
        (state) => controller.offset.clamp(0, 100) / 100,
      ),
    );
    ref.onDispose(controller.dispose);
    return controller;
  },
);

final _scrollOffsetRatioProvider = StateProvider.autoDispose.family<double, String>(
  (ref, title) => 0,
);

class _VerticalPaddingPersistantHeaderDelegate extends SliverPersistentHeaderDelegate {
  
  final double padding;

  const _VerticalPaddingPersistantHeaderDelegate({required this.padding});

  @override
  double get maxExtent => padding;
  @override
  double get minExtent => padding;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => const SizedBox(
    height: 30,
  );
}


class _SettingsSliverHeader extends ConsumerWidget {

  final String title;

  const _SettingsSliverHeader(this.title);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final ratio = ref.watch(_scrollOffsetRatioProvider(title));
    final double elevation = ratio > 0.8 ? ratio * kDefaultElevation : 0;
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: kPaddingMain * 1 + ratio),
      sliver: SliverAppBar(
        automaticallyImplyLeading: false,
        pinned: true,
        elevation: elevation,
        scrolledUnderElevation: elevation,
        toolbarHeight: kTopBarHeight,
        collapsedHeight: kTopBarHeight,
        expandedHeight: screenHeight * 0.2,
        backgroundColor: Color.lerp(
          theme.colorScheme.background,
          theme.colorScheme.surface,
          ratio,
        ),
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          expandedTitleScale: screenHeight * 0.2 / kTopBarHeight,
          centerTitle: true,
          title: FittedBox(
            child: Text(
              title,
              style: theme.textTheme.titleLarge,
            ),
          ),
        ),
      ),
    );
  }
}
