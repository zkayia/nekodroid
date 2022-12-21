
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/base.search/providers/last_query.dart';
import 'package:nekodroid/routes/base.search/providers/query.dart';
import 'package:nekodroid/routes/base.search/providers/range_values.dart';
import 'package:nekodroid/routes/base.search/providers/search_results.dart';
import 'package:nekodroid/routes/base.search/providers/selectable_filters.dart';
import 'package:nekodroid/routes/base.search/providers/text_controller.dart';
import 'package:nekodroid/routes/base.search/widgets/filters_dialog.dart';
import 'package:nekodroid/widgets/anime_list_view.dart';
import 'package:nekodroid/widgets/anime_card.dart';
import 'package:nekodroid/widgets/anime_list_tile.dart';
import 'package:nekodroid/widgets/generic_cached_image.dart';
import 'package:nekodroid/widgets/labelled_icon.dart';
import 'package:nekodroid/widgets/large_icon.dart';
import 'package:nekodroid/widgets/generic_route.dart';


class SearchRoute extends ConsumerWidget {

  const SearchRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    ref
      ..watch(lastTextQueryProv)
      ..watch(selectableFiltersProv)
      ..watch(scoreFilterProv)
      ..watch(popularityFilterProv);
    return GenericRoute(
      hideExitFab: ref.watch(settingsProv.select((v) => !v.search.fabEnabled)),
      resizeToAvoidBottomInset:
        ref.watch(settingsProv.select((v) => v.search.fabMoveWithKeyboard)),
      body: Stack(
        children: [
          ref.watch(searchResultsProv).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stackTrace) => const Center(child: Icon(Boxicons.bxs_error_circle)),
            data: (results) => AnimeListView(
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
                    image: GenericCachedImage(anime.thumbnailUri),
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
                controller: ref.watch(textControllerProv),
                autocorrect: false,
                autofocus: true,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: const Icon(Boxicons.bx_x),
                    splashRadius: kTopBarHeight / 2,
                    color: bodyLarge?.color,
                    onPressed: () {
                      if (ref.read(textControllerProv).text.isNotEmpty) {
                        return ref.read(textControllerProv).clear();
                      }
                      if (ref.read(settingsProv).search.clearButtonExitWhenNoQuery) {
                        Navigator.of(context).pop();
                      }
                    },
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
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => const FiltersDialog(),
                      ).then((_) => _refreshResults(ref));
                    },
                  ),
                ),
                onChanged: (text) {
                  if (ref.read(lastTextQueryProv) != text) {
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
    ..read(lastTextQueryProv.notifier).update(
      (_) => ref.read(textControllerProv).text,
    )
    ..read(queryProv.notifier).build()
    ..invalidate(searchResultsProv);
}
