
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/constants/searchdb_status.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/extensions/neko_sama.dart';
import 'package:nekodroid/provider/api.dart';
import 'package:nekodroid/provider/searchdb_status.dart';
import 'package:nekodroid/routes/base/providers/recent_searches.dart';
import 'package:nekodroid/widgets/anime_list_view.dart';
import 'package:nekodroid/widgets/anime_card.dart';
import 'package:nekodroid/widgets/anime_list_tile.dart';
import 'package:nekodroid/widgets/generic_cached_image.dart';
import 'package:nekodroid/widgets/generic_dialog.dart';
import 'package:nekodroid/widgets/labelled_icon.dart';
import 'package:nekodroid/widgets/large_icon.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class SearchPage extends ConsumerWidget {

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Stack(
    children: [
      Center(
        child: ValueListenableBuilder<Box>(
          valueListenable: Hive.box("misc-data").listenable(
            keys: const ["recent-searches"],
          ),
          builder: (context, miscBox, _) => ref.watch(
            recentSearchesProv(miscBox.get("recent-searches") as List?),
          ).when(
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Icon(Boxicons.bx_error_circle),
            data: (searches) => AnimeListView(
              itemCount: searches.isEmpty ? 0 : searches.length + 1,
              placeholder: LabelledIcon.vertical(
                icon: const LargeIcon(Boxicons.bx_question_mark),
                label: context.tr.searchNoRecent,
              ),
              itemBuilder: (context, index) {
                if (index == 0) {
                  final titleLarge = Theme.of(context).textTheme.titleLarge;
                  return ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: kMinInteractiveDimension),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SingleLineText(
                            context.tr.searchRecents,
                            style: titleLarge,
                          ),
                        ),
                        const SizedBox(width: kPaddingSecond),
                        IconButton(
                          onPressed: () => showDialog<bool>(
                            context: context,
                            builder: (context) => GenericDialog.confirm(
                              title: context.tr.searchRecentsClearConfirm,
                              child: Text(context.tr.searchRecentsClearConfirmDesc),
                            ),
                          ).then((value) {
                            if (value ?? false) {
                              miscBox.clear();
                            }
                          }),
                          icon: Icon(
                            Boxicons.bx_trash,
                            color: titleLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final element = searches.elementAt(index - 1);
                return AnimeListTile(
                  title: element.title,
                  leading: AnimeCard(
                    image: GenericCachedImage(
                      element.thumbnailUri,
                      cacheHeight: kAnimeListTileMaxHeight,
                      cacheWidth: kAnimeListTileMaxHeight * 5 / 7,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pushNamed(
                    "/anime",
                    arguments: element.urlUri,
                  ),
                  trailing: IconButton(
                    onPressed: () => miscBox.put(
                      "recent-searches",
                      (miscBox.get("recent-searches") as List?)?.cast<int>().where(
                        (e) => e != element.id,
                      ).toList(),
                    ),
                    icon: const Icon(Boxicons.bx_x),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      if (ref.watch(searchdbStatusProv).inProcess)
        const LinearProgressIndicator(),
      Card(
        margin: const EdgeInsets.all(kPaddingSecond),
        child: InkWell(
          borderRadius: BorderRadius.circular(kBorderRadMain),
          onTap: ref.watch(searchdbStatusProv) == SearchdbStatus.ready
            ? () => Navigator.of(context).pushNamed("/base/search")
            : ref.watch(searchdbStatusProv).inProcess
              ? null
              : () => ref.read(apiProv).populateSearchdb(ref),
          onLongPress: () => ref.read(apiProv).populateSearchdb(ref),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: kTopBarHeight),
            child: LabelledIcon.horizontal(
              icon: Icon(ref.watch(searchdbStatusProv).icon),
              label: context.tr.searchdbStatus(ref.watch(searchdbStatusProv).name),
            ),
          ),
        ),
      ),
    ],
  );
}
