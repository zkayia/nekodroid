
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/routes/base/widgets/anime_listview.dart';
import 'package:nekodroid/schemas/isar_search_anime.dart';
import 'package:nekodroid/widgets/anime_card.dart';
import 'package:nekodroid/widgets/anime_list_tile.dart';
import 'package:nekodroid/widgets/generic_image.dart';
import 'package:nekodroid/widgets/labelled_icon.dart';
import 'package:nekodroid/widgets/large_icon.dart';
import 'package:nekodroid/widgets/generic_route.dart';


/* CONSTANTS */




/* MODELS */




/* PROVIDERS */

final _textControllerProv = Provider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);

final _lastTextQueryProv = StateProvider.autoDispose<String?>(
  (ref) => null,
);

final _searchResultsProv = FutureProvider.autoDispose<List<IsarSearchAnime>>(
  (ref) {
    final isar = Isar.getInstance()!;
    final words = Isar.splitWords(ref.watch(_textControllerProv).text);
    if (words.isEmpty) {
      return [];
    }
    return isar.txn(() {
      var query = isar.isarSearchAnimes.filter();
      for (final word in words.sublist(0, words.length - 1)) {
        query = query.searchTitlesElementContains(word, caseSensitive: false);
      }
      return query
        .searchTitlesElementContains(words.last, caseSensitive: false)
        .sortByPopularityDesc()
        .build()
        .findAll();
    });
  },
);


/* MISC */




/* WIDGETS */




class SearchRoute extends ConsumerWidget {

  const SearchRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    ref.watch(_lastTextQueryProv);
    return GenericRoute(
      body: Stack(
        children: [
          ref.watch(_searchResultsProv).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stackTrace) => const Center(child: Icon(Boxicons.bxs_error_circle)),
            data: (results) => AnimeListview(
              itemCount: results.length,
              bottomElementPadding: kFabSize + 16,
              placeholder: LabelledIcon.vertical(
                icon: const LargeIcon(Boxicons.bx_question_mark),
                label: context.tr.searchNoResults,
              ),
              onRefresh: () async => _refreshResults(ref),
              itemBuilder: (context, index) {
                final anime = results.elementAt(index);
                return AnimeListTile(
                  title: anime.title,
                  subtitle: anime.dataText(context),
                  leading: AnimeCard(
                    image: GenericImage(anime.thumbnailUri),
                  ),
                  onTap: () {
                    final miscBox = Hive.box("misc-data");
                    miscBox.put(
                      "recent-searches",
                      [
                        anime.id,
                        ...?miscBox.get("recent-searches"),
                      ],
                    );
                    Navigator.of(context).pushNamed(
                      "/anime",
                      arguments: anime.urlUri,
                    );
                  },
                );
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.all(kPaddingSecond),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: kTopBarHeight),
              child: TextField(
                controller: ref.watch(_textControllerProv),
                autocorrect: false,
                autofocus: true,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: const Icon(Boxicons.bx_x),
                    splashRadius: kTopBarHeight / 2,
                    color: bodyLarge?.color,
                    onPressed: () => ref.read(_textControllerProv).text.isNotEmpty
                      ? ref.read(_textControllerProv).clear()
                      : Navigator.of(context).pop(),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Boxicons.bx_filter_alt),
                    splashRadius: kTopBarHeight / 2,
                    color: bodyLarge?.color,
                    onPressed: () {
                      final focus = FocusScope.of(context);
                      if (!focus.hasPrimaryFocus) {
                        focus.unfocus();
                      }
                    },
                  ),
                ),
                onChanged: (text) {
                  if (ref.read(_lastTextQueryProv) != text) {
                    _refreshResults(ref);
                  }
                },
                onSubmitted: (_) => _refreshResults(ref),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _refreshResults(WidgetRef ref) => ref
    ..read(_lastTextQueryProv.notifier).update(
      (_) => ref.read(_textControllerProv).text,
    )
    ..refresh(_searchResultsProv);
}
