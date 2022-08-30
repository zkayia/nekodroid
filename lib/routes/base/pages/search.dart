
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/app_localizations.dart';
import 'package:nekodroid/extensions/ns_anime_extended_base.dart';
import 'package:nekodroid/routes/base/providers/is_in_search.dart';
import 'package:nekodroid/routes/base/providers/search_results.dart';
import 'package:nekodroid/routes/base/widgets/anime_listview.dart';
import 'package:nekodroid/routes/base/widgets/search_bar.dart';
import 'package:nekodroid/routes/base/widgets/search_filters.dart';
import 'package:nekodroid/routes/base/widgets/search_genres_filters.dart';
import 'package:nekodroid/widgets/anime_card.dart';
import 'package:nekodroid/widgets/anime_list_tile.dart';
import 'package:nekodroid/widgets/generic_image.dart';
import 'package:nekodroid/widgets/labelled_icon.dart';
import 'package:nekodroid/widgets/large_icon.dart';


class SearchPage extends ConsumerWidget {

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Stack(
    children: [
      ref.watch(searchResultsProvider).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stackTrace) => const Center(
          child: LargeIcon(Boxicons.bxs_error_circle),
        ),
        data: (data) {
          if (data == null) {
            return ref.read(isInSearchProvider)
              ? const LargeIcon(Boxicons.bxs_error_circle)
              : ListView(
                physics: kDefaultScrollPhysics,
                padding: EdgeInsets.only(
                  top: kPaddingSecond * 2
                    + kTopBarHeight * MediaQuery.of(context).textScaleFactor,
                  left: kPaddingMain,
                  right: kPaddingMain,
                  bottom: kPaddingSecond * 2 + kBottomBarHeight,
                ),
                children: const [
                  SearchGenresFilters(),
                  SizedBox(height: kPaddingMain),
                  SearchFilters(),
                ],
              );
          }
          return AnimeListview(
            itemCount: data.length,
            placeholder: LabelledIcon.vertical(
              icon: const LargeIcon(Boxicons.bx_question_mark),
              label: context.tr.searchNoResults,
            ),
            onRefresh: () async => ref.refresh(searchResultsProvider),
            itemBuilder: (context, index) {
              final anime = data.elementAt(index);
              return AnimeListTile(
                title: anime.title,
                subtitle: anime.dataText(context),
                leading: AnimeCard(image: GenericImage(anime.thumbnail)),
                onTap: () => Navigator.of(context).pushNamed(
                  "/anime",
                  arguments: anime.url,
                ),
              );
            },
          );
        },
      ),
      const Align(
        alignment: Alignment.topCenter,
        child: SearchBar(),
      ),
    ],
  );
}
