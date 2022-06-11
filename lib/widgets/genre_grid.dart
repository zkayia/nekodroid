
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';


class GenreGrid extends StatelessWidget {

	final List<Widget> genres;

	const GenreGrid({
		Key? key,
		required this.genres,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) => Wrap(
		children: genres,
		clipBehavior: Clip.hardEdge,
		crossAxisAlignment: WrapCrossAlignment.center,
		runSpacing: kPaddingGenresGrid,
		spacing: kPaddingGenresGrid,
	);
}
