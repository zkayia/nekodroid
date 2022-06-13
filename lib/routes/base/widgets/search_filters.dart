
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/routes/base/providers/selectable_filters.dart';
import 'package:nekodroid/routes/base/widgets/checkbox_column.dart';
import 'package:nekodroid/routes/base/widgets/checkbox_column_tile.dart';
import 'package:nekosama_dart/nekosama_dart.dart';


class SearchFilters extends ConsumerWidget {

	const SearchFilters({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) => Row(
		mainAxisAlignment: MainAxisAlignment.spaceBetween,
		crossAxisAlignment: CrossAxisAlignment.start,
		children: [
			for (final column in [
				["format".tr(), NSTypes.values],
				null,
				["status".tr(), NSStatuses.values],
			])
				if (column == null)
					const SizedBox(width: kPaddingSecond)
				else
					Expanded(
						child: CheckboxColumn(
							title: column.first as String,
							tiles: [
								...(column.last as List<Enum>).map(
									(e) => CheckboxColumnTile(
										label: "types-statuses-list".tr(gender: e.name),
										value: ref.watch(selectableFiltersProvider).contains(e),
										onChanged: () =>
											ref.read(selectableFiltersProvider.notifier).toggle(e),
									),
								),
							],
						),
					),
		],
	);
}
