
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/provider/searchdb.dart';
import 'package:nekodroid/routes/base/providers/is_in_search.dart';
import 'package:nekodroid/routes/base/providers/selectable_filters.dart';
import 'package:nekodroid/routes/base/providers/search_text_controller.dart';
import 'package:nekosama_dart/nekosama_dart.dart';


final searchResultsProvider = FutureProvider.autoDispose<List<NSSearchAnime>?>(
  (ref) async {
    if (!ref.watch(isInSearchProvider)) {
      return null;
    }
    final filters = ref.watch(selectableFiltersProvider);
    final text = ref.watch(searchTextControllerProvider).value.text;
    return (await ref.watch(searchdbProvider.future)).searchAnimes(
      title: text.isEmpty ? null : NSStringQuery.contains(text),
      genresHasAll: filters.whereType<NSGenres>(),
      statusesIsAny: filters.whereType<NSStatuses>(),
      typesIsAny: filters.whereType<NSTypes>(),
    );
  },
);
