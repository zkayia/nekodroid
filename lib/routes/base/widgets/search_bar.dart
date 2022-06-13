
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/routes/base/providers/is_in_search.dart';
import 'package:nekodroid/routes/base/providers/search_results.dart';
import 'package:nekodroid/routes/base/providers/search_text_controller.dart';
import 'package:nekodroid/routes/base/providers/selectable_filters.dart';


class SearchBar extends ConsumerWidget {

	const SearchBar({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		ref.watch(selectableFiltersProvider);
		return const _SearchBar();
	}
}

class _SearchBar extends ConsumerWidget {

	// ignore: unused_element
	const _SearchBar({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) => Card(
		margin: const EdgeInsets.all(kPaddingSecond),
		child: ConstrainedBox(
			constraints: const BoxConstraints(minHeight: kTopBarHeight),
			child: TextField(
				controller: ref.watch(searchTextControllerProvider),
				autocorrect: false,
				// autofocus: true,
				textAlignVertical: TextAlignVertical.center,
				decoration: InputDecoration(
					prefixIcon: ref.watch(isInSearchProvider)
						? IconButton(
							icon: const Icon(Boxicons.bx_arrow_back),
							color: Theme.of(context).textTheme.bodyLarge?.color,
							onPressed: () {
								ref.read(isInSearchProvider.notifier).update((state) => !state);
								ref.refresh(searchResultsProvider);
							},
						)
						: null,
					suffixIcon: IconButton(
						icon: Icon(
							ref.watch(isInSearchProvider)
								? Boxicons.bx_x
								: Boxicons.bx_search,
						),
						color: Theme.of(context).textTheme.bodyLarge?.color,
						onPressed: () {
							if (ref.read(isInSearchProvider)) {
								ref.read(searchTextControllerProvider).text = "";
								ref.refresh(selectableFiltersProvider);
							} else {
								final focus = FocusScope.of(context);
								if (!focus.hasPrimaryFocus) {
									focus.unfocus();
								}
							}
							ref.read(isInSearchProvider.notifier).update((state) => !state);
							ref.refresh(searchResultsProvider);
						},
					),
				),
				onSubmitted: (text) {
					ref.read(isInSearchProvider.notifier).update((state) => true);
					ref.refresh(searchResultsProvider);
				},
			),
		),
	);
}
