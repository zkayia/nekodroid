import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nekodroid/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/core/database/database.dart';
import 'package:nekodroid/core/extensions/build_context.dart';
import 'package:nekodroid/core/extensions/datetime.dart';
import 'package:nekodroid/core/extensions/double.dart';
import 'package:nekodroid/core/extensions/list.dart';
import 'package:nekodroid/core/extensions/string.dart';
import 'package:nekodroid/core/extensions/text_style.dart';
import 'package:nekodroid/core/utils/network.dart';
import 'package:nekodroid/core/widgets/cached_rounded_network_image.dart';
import 'package:nekodroid/core/widgets/labelled_icon.dart';
import 'package:nekodroid/core/widgets/sliver_scaffold.dart';
import 'package:nekodroid/features/anime/logic/anime.dart';
import 'package:nekodroid/features/anime/logic/episode_list_order.dart';
import 'package:nekodroid/features/anime/logic/episodes_progress.dart';
import 'package:nekodroid/features/anime/logic/lists_dialog.dart' hide ListsDialog;
import 'package:nekodroid/features/anime/widgets/lists_dialog.dart';
import 'package:nekodroid/features/library/logic/anime_is_in_library.dart';
import 'package:nekodroid/features/player/data/player_route_params.dart';
import 'package:nekodroid/features/search/logic/search_filters.dart';
import 'package:share_plus/share_plus.dart';

class AnimeScreen extends ConsumerWidget {
  final Uri? url;

  const AnimeScreen({
    required this.url,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (url == null) {
      return Center(
        child: LabelledIcon.vertical(
          icon: const Icon(Symbols.error_rounded),
          label: "Anime invalide",
          action: TextButton(
            onPressed: context.pop,
            child: const Text("Exit"),
          ),
        ),
      );
    }
    return SliverScaffold(
      actions: [
        IconButton(
          onPressed: () async {
            final result = await showModalBottomSheet<Map<LibraryList, bool>?>(
              context: context,
              isScrollControlled: true,
              constraints: BoxConstraints(maxHeight: context.mq.size.height * 0.8),
              builder: (context) => ListsDialog(url: url!),
            );
            if (result != null) {
              ref.read(listsDialogProvider(url!).notifier).applyChanges(result);
            }
          },
          icon: ref.watch(animeIsInLibraryProvider(url!)).maybeWhen(
                data: (inLibrary) => Icon(
                  inLibrary ? Symbols.library_add_check_rounded : Symbols.library_add,
                  fill: inLibrary ? 1 : 0,
                ),
                orElse: () => const Icon(Symbols.library_add),
              ),
        ),
        IconButton(
          onPressed: () => Share.share(
            url.toString(),
            subject: ref.read(animeProvider(url!)).valueOrNull?.title,
          ),
          icon: const Icon(Symbols.share_rounded, fill: 1),
        ),
        IconButton(
          onPressed: () => NetworkUtils.launchUrl(url!, context),
          icon: const Icon(Symbols.open_in_browser_rounded),
        ),
      ],
      body: RefreshIndicator(
        onRefresh: () => ref.read(animeProvider(url!).notifier).refresh(),
        child: Center(
          child: ref.watch(animeProvider(url!)).when(
                loading: CircularProgressIndicator.new,
                error: (error, stackTrace) => Text("$error\n$stackTrace"),
                data: (anime) {
                  final episodesProgress = ref.watch(episodesProgressProvider(anime.url)).valueOrNull;
                  return OrientationBuilder(
                    builder: (context, orientation) {
                      final animeThumbHeight =
                          orientation == Orientation.portrait ? context.mq.size.height * 0.25 : context.mq.size.height * 0.5;
                      return Scrollbar(
                        child: ListView(
                          padding: const EdgeInsets.all(kPadding),
                          children: [
                            Row(
                              children: [
                                CachedRoundedNetworkImage(
                                  anime.thumbnail.toString(),
                                  height: animeThumbHeight,
                                  width: animeThumbHeight * 5 / 7,
                                ),
                                const SizedBox(width: kPadding),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      for (final (icon, label) in [
                                        (
                                          Symbols.calendar_month_rounded,
                                          "${anime.startDate?.toPrettyMonth() ?? "?"} • ${anime.endDate?.toPrettyMonth() ?? "?"}"
                                        ),
                                        (Symbols.star_rounded, "${anime.score.toPrettyString()} / 5"),
                                        (Symbols.live_tv_rounded, anime.type.displayName.toTitleCase()),
                                        (Symbols.hourglass_empty_rounded, anime.status.displayName.toTitleCase()),
                                        (Symbols.format_list_numbered_rounded, "${anime.episodeCount ?? "?"} Eps"),
                                      ])
                                        LabelledIcon.horizontal(
                                          icon: Icon(icon),
                                          labelWidget: Flexible(child: Text(label)),
                                        ),
                                    ].withSeparator(const SizedBox(height: kPadding)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: kPadding),
                            Text(
                              anime.title,
                              style: context.th.textTheme.titleMedium.bold(),
                            ),
                            Wrap(
                              spacing: kPadding,
                              children: [
                                for (final genre in anime.genres)
                                  GestureDetector(
                                    onTap: () => context.push("/search", extra: SearchFiltersState(genres: {genre})),
                                    child: Text(
                                      "#${genre.displayName.toTitleCase()}",
                                      style: context.th.textTheme.labelLarge.bold(),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: kPadding),
                            Text(anime.synopsis ?? "Aucun synopsis pour le moment."),
                            const SizedBox(height: kPadding),
                            ListTile(
                              contentPadding: const EdgeInsets.only(right: 16),
                              leading: IconButton(
                                onPressed: () => ref.read(episodeListOrderProvider.notifier).invert(),
                                icon: const Icon(Symbols.swap_vert_rounded),
                              ),
                              title: Text(
                                "Episodes",
                                style: context.th.textTheme.titleMedium.bold(),
                              ),
                              trailing: Card(
                                margin: EdgeInsets.zero,
                                child: IconButton(
                                  onPressed: () async {
                                    try {
                                      final index = await ref
                                          .read(animeProvider(url!).notifier)
                                          .getEpToPlayIndex(anime.episodeCount ?? anime.episodes.length);
                                      if (context.mounted) {
                                        context.push(
                                          "/player",
                                          extra: PlayerRouteParams(
                                            episode: anime.episodes.reversed.elementAt(index),
                                            title: anime.title,
                                            anime: anime,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      Fluttertoast.showToast(msg: "Impossible de trouver l'épisode à jouer");
                                    }
                                  },
                                  icon: const Icon(Symbols.play_arrow_rounded, fill: 1),
                                ),
                              ),
                            ),
                            const Divider(),
                            for (int i = switch (ref.watch(episodeListOrderProvider)) {
                              EpisodeListOrderState.asc => anime.episodes.length - 1,
                              EpisodeListOrderState.desc => 0,
                            };
                                switch (ref.watch(episodeListOrderProvider)) {
                              EpisodeListOrderState.asc => i >= 0,
                              EpisodeListOrderState.desc => i < anime.episodes.length,
                            };
                                switch (ref.watch(episodeListOrderProvider)) {
                              EpisodeListOrderState.asc => i--,
                              EpisodeListOrderState.desc => i++,
                            })
                              ListTile(
                                onTap: () => context.push(
                                  "/player",
                                  extra: PlayerRouteParams(
                                    episode: anime.episodes.elementAt(i),
                                    title: anime.title,
                                    anime: anime,
                                  ),
                                ),
                                title: Text("Episode ${anime.episodes.elementAt(i).episodeNumber}"),
                                trailing: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Icon(Symbols.play_arrow_rounded),
                                    Transform.flip(
                                      flipX: true,
                                      child: CircularProgressIndicator(
                                        backgroundColor: context.th.colorScheme.surface,
                                        strokeCap: StrokeCap.round,
                                        strokeAlign: BorderSide.strokeAlignInside,
                                        value: episodesProgress?[anime.episodes.elementAt(i).episodeNumber] ?? 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
        ),
      ),
    );
  }
}
