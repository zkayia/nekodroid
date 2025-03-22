import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:nekodroid/features/search/logic/search_filters.dart';
import 'package:nekodroid/features/search/logic/search_query.dart';
import 'package:nekodroid/features/search/logic/search_results.dart';
import 'package:nekodroid/features/search/widgets/filters_dialog.dart';
import 'package:nekodroid/features/search/widgets/search_anime_tile.dart';

class SearchScreen extends ConsumerWidget {
  final SearchFiltersState? initialFilters;

  const SearchScreen({
    this.initialFilters,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(searchQueryProvider);
    ref.watch(searchFiltersProvider(initialFilters));
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            textAlignVertical: TextAlignVertical.center,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Rechercher...",
              border: InputBorder.none,
              suffixIcon: IconButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    constraints: BoxConstraints(maxHeight: context.mq.size.height * 0.8),
                    builder: (context) => FiltersDialog(initialFilters: initialFilters),
                  ).then((_) => ref.invalidate(searchResultsProvider(initialFilters)));
                },
                icon: Icon(
                  ref.watch(searchFiltersProvider(initialFilters).select((v) => v.isEmpty))
                      ? Symbols.filter_alt
                      : Symbols.filter_alt_rounded,
                ),
              ),
            ),
            onChanged: (value) => ref
              ..read(searchQueryProvider.notifier).updateQuery(value)
              ..invalidate(searchResultsProvider(initialFilters)),
            onSubmitted: (value) => ref
              ..read(searchQueryProvider.notifier).updateQuery(value)
              ..invalidate(searchResultsProvider(initialFilters)),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => ref.refresh(searchResultsProvider(initialFilters).future),
          child: ref.watch(searchResultsProvider(initialFilters)).when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(child: Text(error.toString())),
                data: (results) => ListView.builder(
                  padding: const EdgeInsets.all(kPadding),
                  itemCount: results.length,
                  itemBuilder: (context, index) => SearchAnimeTile(results.elementAt(index)),
                ),
              ),
        ),
      ),
    );
  }
}
// final anime = SearchAnime(
//   animeId: 3458,
//   title: "Fullmetal Alchemist: Brotherhood",
//   genres: [NSGenres.action, NSGenres.adventure, NSGenres.drama, NSGenres.fantasy, NSGenres.military],
//   source: NSSources.vostfr,
//   status: NSStatuses.aired,
//   type: NSTypes.tv,
//   score: 4.65,
//   url: Uri.parse("https://neko-sama.fr/anime/info/3458-hagane-no-renkinjutsushi-fullmetal-alchemist_vostfr"),
//   thumbnail: Uri.https(NSConfig.host, "/assets/images_main/main_3458_226mhyBWAID.jpg"),
//   year: 2009,
//   popularity: 11.040026916674956,
// );
