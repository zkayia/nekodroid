
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';


class GenreGrid extends StatelessWidget {

	final List<Widget> genres;

	const GenreGrid({
		super.key,
		required this.genres,
	});

	@override
	Widget build(BuildContext context) => Wrap(
		clipBehavior: Clip.hardEdge,
		crossAxisAlignment: WrapCrossAlignment.center,
		runSpacing: kPaddingGenresGrid,
		spacing: kPaddingGenresGrid,
		children: genres,
	);
}
