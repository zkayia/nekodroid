import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:nekodroid/core/extensions/string.dart';
import 'package:nekodroid/features/search/logic/search_filters.dart';
import 'package:nekosama/nekosama.dart';

class FiltersDialogSelectable extends ConsumerWidget {
  final List values;
  final SearchFiltersState? initialFilters;

  const FiltersDialogSelectable(
    this.values, {
    this.initialFilters,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Wrap(
        clipBehavior: Clip.hardEdge,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: kPadding,
        spacing: kPadding / 2,
        children: [
          ...values.map(
            (e) {
              final selected = switch (e) {
                final NSSources source => ref.watch(searchFiltersProvider(initialFilters)).sources.contains(source),
                final NSTypes type => ref.watch(searchFiltersProvider(initialFilters)).types.contains(type),
                final NSStatuses status => ref.watch(searchFiltersProvider(initialFilters)).statuses.contains(status),
                final NSGenres genre => ref.watch(searchFiltersProvider(initialFilters)).genres.contains(genre),
                _ => false,
              };
              return FilterChip.elevated(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero,
                showCheckmark: false,
                backgroundColor: context.th.colorScheme.surface,
                label: Text(
                  (e.displayName as String).toTitleCase(),
                  style: selected ? null : context.th.textTheme.labelLarge,
                ),
                selected: selected,
                onSelected: (selected) => ref.read(searchFiltersProvider(initialFilters).notifier).setEnum(e, selected),
              );
            },
          ),
        ],
      );
}
