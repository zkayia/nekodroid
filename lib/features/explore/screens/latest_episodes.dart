import 'package:nekodroid/constants.dart';
import 'package:nekodroid/core/widgets/sliver_scaffold.dart';
import 'package:nekodroid/features/explore/logic/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/features/explore/widgets/new_episode_tile.dart';

class ExploreLatestEpisodesScreen extends ConsumerWidget {
  const ExploreLatestEpisodesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverScaffold(
        title: const Text("Derniers épisodes"),
        body: ref.watch(homeProvider).when(
              loading: CircularProgressIndicator.new,
              error: (error, stackTrace) => Text(error.toString()),
              data: (data) => RefreshIndicator(
                onRefresh: () => ref.refresh(homeProvider.future),
                child: Scrollbar(
                  child: OrientationBuilder(
                    builder: (context, orientation) => GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                        childAspectRatio: 16 / 9,
                        crossAxisSpacing: kPadding,
                        mainAxisSpacing: kPadding,
                      ),
                      padding: const EdgeInsets.all(kPadding),
                      itemCount: data.newEpisodes.length,
                      itemBuilder: (context, index) => NewEpisodeTile(data.newEpisodes.elementAt(index)),
                    ),
                  ),
                ),
              ),
            ),
      );
}
