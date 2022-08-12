
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class GenreChip extends StatelessWidget {

	final bool _isSelectable;
	final String label;
	final void Function() onTap;
	final bool selected;

	const GenreChip.click({
		required this.label,
		required this.onTap,
		super.key,
	}) :
		_isSelectable = false,
		selected = false;

	const GenreChip.select({
		required this.label,
		required this.selected,
		required this.onTap,
		super.key,
	}) :
		_isSelectable = true;

	@override
	Widget build(BuildContext context) => _isSelectable
		? Builder(
			builder: (context) {
				final theme = Theme.of(context);
				return TextButton(
					clipBehavior: Clip.hardEdge,
					onPressed: onTap,
					style: const ButtonStyle().copyWith(
						elevation: MaterialStateProperty.all(
							kDefaultElevation / (selected ? 2 : 8),
						),
						backgroundColor: MaterialStateProperty.all(
							selected
								? theme.colorScheme.primary
								: theme.colorScheme.surface,
						),
					),
					child: SingleLineText(
						label,
						style: selected
							? theme.textTheme.bodyMedium?.copyWith(
								color: theme.colorScheme.onPrimary,
							)
							: theme.textTheme.bodyMedium,
					),
				);
			},
		)
		: TextButton(
			clipBehavior: Clip.hardEdge,
			onPressed: onTap,
			style: const ButtonStyle().copyWith(
				elevation: MaterialStateProperty.all(kDefaultElevation / 8),
			),
			child: SingleLineText.secondary(label),
		);
}
