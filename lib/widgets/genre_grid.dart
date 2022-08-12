
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';


class GenreGrid extends StatelessWidget {

	final List<Widget> genres;

	const GenreGrid({
		required this.genres,
		super.key,
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
