import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:nekodroid/core/extensions/datetime.dart';
import 'package:nekodroid/core/extensions/text_style.dart';
import 'package:nekodroid/core/extensions/uri.dart';
import 'package:nekodroid/core/widgets/cached_rounded_network_image.dart';
import 'package:nekodroid/features/history/logic/history.dart';

class HistoryTile extends ConsumerWidget {
  final (EpisodeHistoryData, Anime) entry;

  const HistoryTile(this.entry, {super.key});

  static const double _historyTileHeight = 96;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ConstrainedBox(
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
                          maxLines: 2,
                        ),
                        Text(entry.$1.time.toPrettyDayMonthHour()),
                        Text("Episode ${entry.$1.episodeNumber}"),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          "Supprimer cet élément ?",
                          style: context.th.textTheme.titleMedium.bold(),
                        ),
                        actions: [
                          TextButton(onPressed: () => context.nav.pop(false), child: const Text("Non")),
                          ElevatedButton(onPressed: () => context.nav.pop(true), child: const Text("Oui")),
                        ],
                      ),
                    );
                    if (result ?? false) {
                      ref.read(historyProvider.notifier).deleteEntry(entry.$1);
                    }
                  },
                  icon: const Icon(Symbols.delete_rounded),
                ),
              ],
            ),
          ),
        ),
      );
}
