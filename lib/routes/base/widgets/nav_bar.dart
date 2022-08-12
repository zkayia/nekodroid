
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/routes/base/models/nav_bar_item.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class NavBar extends ConsumerWidget {

	final List<NavBarItem> items;
	final void Function(int index) onTap;
	final int currentIndex;
	final bool showSelectedDot;
	final bool showSelectedLabels;
	final bool showUnselectedLabels;

	const NavBar({
		required this.items,
		required this.onTap,
		this.currentIndex=0,
		this.showSelectedDot=true,
		this.showSelectedLabels=true,
		this.showUnselectedLabels=true,
		super.key,
	});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final theme = Theme.of(context);
		return GestureDetector(
			onHorizontalDragEnd: (details) {
				if (details.primaryVelocity != null) {
					final newIndex = (
						currentIndex + (details.primaryVelocity! > 0 ? 1 : -1)
					).clamp(0, items.length - 1);
					if (details.primaryVelocity!.abs() > 200 && currentIndex != newIndex) {
						onTap(newIndex);
					}
				}
			},
			child: Card(
				margin: const EdgeInsets.all(kPaddingSecond),
				shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(kBorderRadMain),
				),
				child: Row(
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: List.generate(
						growable: false,
						items.length,
						(index) {
							final item = items.elementAt(index);
							final isSelected = currentIndex == index;
							final label = SingleLineText(
								item.label!,
								style: theme.textTheme.bodyLarge?.copyWith(
									color: isSelected ? theme.indicatorColor : null,
								),
							);
							final labelHeight = (label.style?.fontSize ?? 14) + 2;
							return Expanded(
								child: InkWell(
									onTap: () => onTap(index),
									borderRadius: BorderRadius.circular(kBorderRadMain),
									child: ConstrainedBox(
										constraints: const BoxConstraints(
											maxHeight: kBottomBarHeight,
										),
										child: Column(
											mainAxisAlignment: MainAxisAlignment.center,
											children: [
												if (item.icon != null)
													Icon(
														isSelected
															? item.selectedIcon ?? item.icon!
															: item.icon!,
														color: isSelected ? theme.colorScheme.primary : null,
													),
												const SizedBox(height: kDotIndicatorSize),
												AnimatedContainer(
													duration: kDefaultAnimDuration,
													curve: kDefaultAnimCurve,
													height: isSelected
														? item.label != null && showSelectedLabels
															? labelHeight
															: showSelectedDot ? kDotIndicatorSize : 0
														: showUnselectedLabels ? labelHeight : 0,
													child: isSelected
														? item.label != null && showSelectedLabels
															? label
															: showSelectedDot
																? DecoratedBox(
																	decoration: BoxDecoration(
																		shape: BoxShape.circle,
																		color: theme.indicatorColor,
																	),
																	child: const SizedBox.square(dimension: kDotIndicatorSize),
																)
																: null
														: showUnselectedLabels ? label : null,
												),
											],
										),
									),
								),
							);
						}
					),
				),
			),
		);
	}
}
