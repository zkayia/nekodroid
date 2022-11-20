
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/extensions/datetime.dart';
import 'package:nekodroid/extensions/duration.dart';
import 'package:nekodroid/schemas/isar_anime_list_item.dart';
import 'package:nekodroid/widgets/generic_route.dart';


class DetailledHistoryRoute extends StatelessWidget {

  const DetailledHistoryRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final isarAnime = ModalRoute.of(context)!.settings.arguments as IsarAnimeListItem;
    return GenericRoute(
      title: isarAnime.title,
      body: FutureBuilder(
        future: isarAnime.episodeStatuses.load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Icon(Boxicons.bx_error_circle);
          }
          return SingleChildScrollView(
            physics: kDefaultScrollPhysics,
            padding: const EdgeInsets.only(
              top: kPaddingSecond * 2 + kTopBarHeight,
              left: kPaddingMain,
              right: kPaddingMain,
              bottom: kPaddingSecond + kFabSize + 16,
            ),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FlexColumnWidth(),
                1: FlexColumnWidth(2),
              },
              children: [
                for (final episode in isarAnime.episodeStatuses.toList().reversed)
                  TableRow(
                    decoration: episode.episodeNumber.isEven
                      ? BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(kBorderRadSecond),
                      )
                      : null,
                    children: [
                      Text(
                        context.tr.episodeLong(episode.episodeNumber),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: kPaddingMain,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final timestamp in episode.watchedTimestampsSet)
                              Text(
                                "${
                                  DateTime.fromMillisecondsSinceEpoch(
                                    timestamp,
                                  ).prettyToString()
                                } ${context.tr.completed}",
                              ),
                            if (
                              episode.lastPosition != null
                              && episode.lastExitTimestamp != null
                            )
                              Text(
                                context.tr.dateUpToTime(
                                  episode.lastExitDateTime!.prettyToString(),
                                  episode.lastPositionDuration!.prettyToString(),
                                ),
                              )
                            else if (episode.watchedTimestampsSet.isEmpty)
                              Text(context.tr.notWatchedYet),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
