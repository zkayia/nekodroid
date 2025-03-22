import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:nekodroid/core/extensions/range_values.dart';
import 'package:nekodroid/core/extensions/text_style.dart';
import 'package:nekodroid/features/search/logic/search_filters.dart';
import 'package:nekodroid/features/search/widgets/filters_dialog_selectable.dart';
import 'package:nekodroid/features/search/widgets/filters_dialog_title.dart';
import 'package:nekodroid/features/settings/logic/settings.dart';
import 'package:nekosama/nekosama.dart';

class FiltersDialog extends ConsumerWidget {
  final SearchFiltersState? initialFilters;

  const FiltersDialog({
    this.initialFilters,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            right: kPadding,
            left: kPadding,
            bottom: kPadding + context.mq.padding.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Filtres",
                  style: context.th.textTheme.titleLarge.bold(),
                ),
              ),
              if (ref.watch(settingsProvider.select((v) => v.searchSources.length > 1))) ...[
                FiltersDialogTitle(
                  text: "Langue",
                  infoText:
                      "${ref.watch(searchFiltersProvider(initialFilters).select((v) => v.sources.length))}/${NSSources.values.length}",
                ),
                FiltersDialogSelectable(NSSources.values, initialFilters: initialFilters),
              ],
              FiltersDialogTitle(
                text: "Type",
                infoText:
                    "${ref.watch(searchFiltersProvider(initialFilters).select((v) => v.types.length))}/${NSTypes.values.length}",
              ),
              FiltersDialogSelectable(NSTypes.values, initialFilters: initialFilters),
              FiltersDialogTitle(
                text: "Status",
                infoText:
                    "${ref.watch(searchFiltersProvider(initialFilters).select((v) => v.statuses.length))}/${NSStatuses.values.length}",
              ),
              FiltersDialogSelectable(NSStatuses.values, initialFilters: initialFilters),
              FiltersDialogTitle(
                text: "Genre",
                infoText:
                    "${ref.watch(searchFiltersProvider(initialFilters).select((v) => v.genres.length))}/${NSGenres.values.length}",
              ),
              FiltersDialogSelectable(NSGenres.values, initialFilters: initialFilters),
              FiltersDialogTitle(
                text: "Score",
                infoText: ref.watch(searchFiltersProvider(initialFilters).select((v) => v.score?.prettyToString() ?? "")),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding),
                child: RangeSlider(
                  values: ref.watch(searchFiltersProvider(initialFilters).select((v) => v.score ?? const RangeValues(0, 5))),
                  max: 5,
                  min: 0,
                  onChanged: (value) => ref.read(searchFiltersProvider(initialFilters).notifier).updateScore(value),
                ),
              ),
              FiltersDialogTitle(
                text: "Popularité",
                infoText: ref.watch(searchFiltersProvider(initialFilters).select((v) => v.popularity?.prettyToString() ?? "")),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding),
                child: RangeSlider(
                  values:
                      ref.watch(searchFiltersProvider(initialFilters).select((v) => v.popularity ?? const RangeValues(0, 20))),
                  max: 20,
                  min: 0,
                  onChanged: (value) => ref.read(searchFiltersProvider(initialFilters).notifier).updatePopularity(value),
                ),
              ),
              const SizedBox(height: kPadding),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              "Réinitialiser les filtres ?",
                              style: context.th.textTheme.titleMedium.bold(),
                            ),
                            actions: [
                              TextButton(onPressed: () => context.nav.pop(false), child: const Text("Non")),
                              ElevatedButton(onPressed: () => context.nav.pop(true), child: const Text("Oui")),
                            ],
                          ),
                        );
                        if (result ?? false) {
                          ref.read(searchFiltersProvider(initialFilters).notifier).reset();
                        }
                      },
                      child: const Text("Réinitialiser"),
                    ),
                  ),
                  const SizedBox(width: kPadding),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: Navigator.of(context).pop,
                      child: const Text("Fermer"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
