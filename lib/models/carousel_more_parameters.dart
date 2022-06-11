
import 'package:flutter/material.dart';
import 'package:nekodroid/widgets/anime_card.dart';


@immutable
class CarouselMoreParameters {

	final String title;
	final List<AnimeCard> cards;
	
	const CarouselMoreParameters({
		required this.title,
		required this.cards,
	});
}
