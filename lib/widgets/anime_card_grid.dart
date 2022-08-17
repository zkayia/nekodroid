
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/anime_card.dart';


class AnimeCardGrid extends StatelessWidget {

  final List<AnimeCard> cards;
  final EdgeInsetsGeometry? padding;

  const AnimeCardGrid({
    required this.cards,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) => GridView(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      mainAxisSpacing: kPaddingMain,
      crossAxisSpacing: kPaddingSecond,
      crossAxisCount: 3,
      childAspectRatio: 5 / 7,
    ),
    padding: padding,
    physics: kDefaultScrollPhysics,
    children: cards,
  );
}
