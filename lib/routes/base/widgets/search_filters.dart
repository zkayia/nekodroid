
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/app_localizations.dart';
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
      Expanded(
        child: CheckboxColumn(
          title: context.tr.format,
          tiles: [
            ...NSTypes.values.map(
              (e) => CheckboxColumnTile(
                label: context.tr.formats(e.name),
                value: ref.watch(selectableFiltersProvider).contains(e),
                onChanged: () =>
                  ref.read(selectableFiltersProvider.notifier).toggle(e),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(width: kPaddingSecond),
      Expanded(
        child: CheckboxColumn(
          title: context.tr.status,
          tiles: [
            ...NSStatuses.values.map(
              (e) => CheckboxColumnTile(
                label: context.tr.statuses(e.name),
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
