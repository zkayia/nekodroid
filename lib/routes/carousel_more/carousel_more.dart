
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/models/carousel_more_parameters.dart';
import 'package:nekodroid/widgets/anime_card_grid.dart';
import 'package:nekodroid/widgets/generic_route.dart';


class CarouselMoreRoute extends StatelessWidget {

  const CarouselMoreRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CarouselMoreParameters;
    return GenericRoute(
      title: args.title,
      body: AnimeCardGrid(
        padding: const EdgeInsets.only(
          top: kPaddingSecond * 2 + kTopBarHeight,
          left: kPaddingMain,
          right: kPaddingMain,
          bottom: kPaddingSecond * 2 + kBottomBarHeight,
        ),
        cards: args.cards,
      ),
    );
  }
}
