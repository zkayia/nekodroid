
import 'package:flutter/material.dart';
import 'package:nekodroid/models/carousel_more_parameters.dart';
import 'package:nekodroid/widgets/generic_route.dart';
import 'package:nekodroid/widgets/sliver_title_scrollview.dart';
import 'package:nekodroid/widgets/anime_card_grid.dart';


class CarouselMoreRoute extends StatelessWidget {

  const CarouselMoreRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CarouselMoreParameters;
    return GenericRoute(
      body: SliverTitleScrollview(
        title: args.title,
        sliver: AnimeCardGrid.sliver(
          cards: args.cards,
        ),
      ),
    );
  }
}
