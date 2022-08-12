
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/routes/base/widgets/checkbox_column_tile.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class CheckboxColumn extends StatelessWidget {

	final String title;
	final List<CheckboxColumnTile> tiles;

	const CheckboxColumn({
		required this.title,
		required this.tiles,
		super.key,
	});

	@override
	Widget build(BuildContext context) => Column(
		crossAxisAlignment: CrossAxisAlignment.start,
		children: [
			SingleLineText(
				title,
				style: Theme.of(context).textTheme.titleLarge,
			),
			const SizedBox(height: kPaddingSecond),
			...tiles,
		],
	);
}
