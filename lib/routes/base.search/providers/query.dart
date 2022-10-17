
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/routes/base.search/providers/range_values.dart';
import 'package:nekodroid/routes/base.search/providers/selectable_filters.dart';
import 'package:nekodroid/routes/base.search/providers/text_controller.dart';
import 'package:nekodroid/schemas/isar_search_anime.dart';
import 'package:nekosama/nekosama.dart';


final queryProv = StateNotifierProvider.autoDispose<
  _QueryProvNotif,
  Query<IsarSearchAnime>?
>(
  _QueryProvNotif.new,
);

class _QueryProvNotif extends StateNotifier<Query<IsarSearchAnime>?> {

  final Ref ref;

  _QueryProvNotif(this.ref) : super(null);

  void build() => state = Isar.getInstance()!.isarSearchAnimes.filter()
    .allOf<String, Query>(
      Isar.splitWords(ref.read(textControllerProv).text),
      (q, e) => q.searchTitlesElementContains(e, caseSensitive: false),
    )
    .allOf(
      ref.read(selectableFiltersProv),
      (q, e) {
        if (e is NSTypes) {
          return q.typeEqualTo(e);
        } else if (e is NSStatuses) {
          return q.statusEqualTo(e);
        }
        return q.genresElementEqualTo(e as NSGenres);
      }
    )
    .optional(
      ref.read(scoreFilterProv.notifier).hasChanged,
      (q) {
        final score = ref.read(scoreFilterProv);
        return q.scoreBetween(score.start, score.end);
      },
    )
    .optional(
      ref.read(popularityFilterProv.notifier).hasChanged,
      (q) {
        final popularity = ref.read(popularityFilterProv);
        return q.popularityBetween(popularity.start, popularity.end);
      },
    )
    .sortByPopularityDesc()
    .build();
}
