
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/app_localizations.dart';
import 'package:nekodroid/routes/base/providers/selectable_filters.dart';
import 'package:nekodroid/widgets/genre_chip.dart';
import 'package:nekodroid/widgets/genre_grid.dart';
import 'package:nekodroid/widgets/single_line_text.dart';
import 'package:nekosama_hive/nekosama_hive.dart';


class SearchGenresFilters extends ConsumerWidget {

  const SearchGenresFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SingleLineText(
        context.tr.genre,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: kPaddingSecond),
      GenreGrid(
        genres: [
          ...NSGenres.values.map(
            (genre) => GenreChip.select(
              label: context.tr.genres(genre.name),
              selected: ref.watch(selectableFiltersProvider).contains(genre),
              onTap: () =>
                ref.read(selectableFiltersProvider.notifier).toggle(genre),
            ),
          ),
        ],
      ),
    ],
  );
}
