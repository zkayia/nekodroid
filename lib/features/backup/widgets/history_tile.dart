import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:nekodroid/core/extensions/datetime.dart';
import 'package:nekodroid/core/extensions/uri.dart';
import 'package:nekodroid/core/widgets/cached_rounded_network_image.dart';

class HistoryTile extends StatelessWidget {
  final (EpisodeHistoryData, Anime) entry;

  const HistoryTile(this.entry, {super.key});

  static const double _historyTileHeight = 80;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: _historyTileHeight),
        child: InkWell(
          borderRadius: kBorderRadCirc,
          onTap: () => context.push("/anime/${entry.$2.url.encoded}"),
          child: Padding(
            padding: const EdgeInsets.all(kPadding / 2),
            child: Row(
              children: [
                CachedRoundedNetworkImage(
                  entry.$2.thumbnail.toString(),
                  height: _historyTileHeight - kPadding,
                  width: (_historyTileHeight - kPadding) * 5 / 7,
                ),
                const SizedBox(width: kPadding),
                Expanded(
                  child: DefaultTextStyle(
                    style: context.th.textTheme.labelLarge ?? context.defTextStyle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.$2.title,
                          style: context.th.textTheme.titleMedium,
                          maxLines: 3,
                        ),
                        Text(entry.$1.time.toPrettyDayMonthHour()),
                        // Text("${entry.$1.position.prettyToString()} / ${entry.$1.duration.prettyToString()}"),
                        // LabelledIcon.horizontal(
                        //   label: entry.$1.time.toPrettyDayMonthHour(),
                        //   icon: SizedBox.square(
                        //     dimension: context.defTextStyle.fontSize,
                        //     child: Transform.flip(
                        //       flipX: true,
                        //       child: CircularProgressIndicator(
                        //         backgroundColor: context.th.colorScheme.surface,
                        //         strokeCap: StrokeCap.round,
                        //         strokeAlign: BorderSide.strokeAlignInside,
                        //         strokeWidth: 2,
                        //         value: entry.$1.ratio,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  // @override
  // Widget build(BuildContext context) => ListTile(
  //       onTap: () => context.push("/anime/${entry.$2.url.encoded}"),
  //       title: Text(entry.$2.title),
  //       subtitle: Text(entry.$1.time.toPrettyDayMonthHour()),
  //       leading: CachedRoundedNetworkImage(entry.$2.thumbnail.toString()),
  //     );
}
