
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/large_icon.dart';


class AnimeListview extends ConsumerWidget {

	final int itemCount;
	final Widget Function(BuildContext context, int index) itemBuilder;
	final Future<void> Function()? onRefresh;
	final Widget? placeholder;

	const AnimeListview({
		required this.itemCount,
		required this.itemBuilder,
		this.onRefresh,
		this.placeholder,
		super.key,
	});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final listview = itemCount == 0
			? SingleChildScrollView(
				physics: const AlwaysScrollableScrollPhysics(
					parent: kDefaultScrollPhysics,
				),
				child: Center(
					child: SizedBox(
						height: MediaQuery.of(context).size.height,
						child: placeholder ?? const LargeIcon(Boxicons.bx_question_mark),
					),
				),
			)
			: ListView.separated(
				physics: const AlwaysScrollableScrollPhysics(
					parent: kDefaultScrollPhysics,
				),
				padding: const EdgeInsets.only(
					top: kPaddingSecond * 2 + kTopBarHeight,
					left: kPaddingMain,
					right: kPaddingMain,
					bottom: kPaddingSecond * 2 + kBottomBarHeight,
				),
				itemCount: itemCount,
				separatorBuilder: (context, index) => const SizedBox(height: kPaddingSecond),
				itemBuilder: itemBuilder,
			);
		return onRefresh != null
			? RefreshIndicator(
				edgeOffset: kPaddingSecond + kTopBarHeight,
				onRefresh: onRefresh!,
				child: listview,
			)
			: listview;
	}
}
