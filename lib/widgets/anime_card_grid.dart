
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/anime_card.dart';


class AnimeCardGrid extends StatelessWidget {

  final bool isSliver;
  final List<AnimeCard> cards;
  final EdgeInsetsGeometry? padding;

  const AnimeCardGrid({
    required this.cards,
    this.padding,
    super.key,
  }) : isSliver = false;

  const AnimeCardGrid.sliver({
    required this.cards,
    this.padding,
    super.key,
  }) : isSliver = true;

  @override
  Widget build(BuildContext context) {
    final isEpisode = cards.any((e) => e.isEpisode);
    final delegate = SliverGridDelegateWithFixedCrossAxisCount(
      mainAxisSpacing: kPaddingMain,
      crossAxisSpacing: kPaddingSecond,
      crossAxisCount: isEpisode ? 2 : 3,
      childAspectRatio: isEpisode ? 16 / 10 : 5 / 7,
    );
    return isSliver
      ? SliverGrid(
        gridDelegate: delegate,
        delegate: SliverChildListDelegate.fixed(cards),
      )
      : GridView(
        gridDelegate: delegate,
        padding: padding,
        physics: kDefaultScrollPhysics,
        children: cards,
      );
  }
}
