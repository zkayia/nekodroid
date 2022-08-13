
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/generic_route.dart';


class TitleSliverListRoute extends ConsumerWidget {

	final String title;
	final List<Widget> children;
	final Future<bool> Function(BuildContext context)? onExitTap;

	const TitleSliverListRoute({
		required this.title,
		required this.children,
		this.onExitTap,
		super.key,
	});

	@override
	Widget build(BuildContext context, WidgetRef ref) => GenericRoute(
		onExitTap: onExitTap,
		body: CustomScrollView(
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
					padding: const EdgeInsets.only(
						top: kPaddingSecond,
						left: kPaddingMain,
						right: kPaddingMain,
						bottom: kPaddingSecond + kFabSize + 16,
					),
					sliver: SliverList(
						delegate: SliverChildListDelegate.fixed(children),
					),
				),
			],
		),
	);
}

final _scrollControllerProvider = Provider.autoDispose.family<ScrollController, String>(
	(ref, title) {
		final controller = ScrollController();
		controller.addListener(
			() => ref.watch(_scrollOffsetRatioProvider(title).notifier).update(
				(state) => controller.offset.clamp(0, kTopBarHeight) / kTopBarHeight,
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
		return SliverPadding(
			padding: EdgeInsets.symmetric(horizontal: kPaddingSecond * ratio),
			sliver: SliverAppBar(
				automaticallyImplyLeading: false,
				pinned: true,
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
