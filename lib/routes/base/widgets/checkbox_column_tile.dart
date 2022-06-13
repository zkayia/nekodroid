
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class CheckboxColumnTile extends StatelessWidget {

	final String label;
	final bool value;
	final void Function() onChanged;

	const CheckboxColumnTile({
		super.key,
		required this.label,
		required this.value,
		required this.onChanged,
	});

	@override
	Widget build(BuildContext context) => Card(
		margin: const EdgeInsets.only(bottom: kPaddingSecond),
		elevation: kDefaultElevation / (value ? 2 : 8),
		child: Material(
			borderRadius: BorderRadius.circular(kBorderRadMain),
			color: Theme.of(context).listTileTheme.tileColor,
			child: InkWell(
				borderRadius: BorderRadius.circular(kBorderRadMain),
				onTap: onChanged,
				child: Row(
					children: [
						Checkbox(
							value: value,
							onChanged: (value) => onChanged(),
						),
						Flexible(
							child: SingleLineText(
								label,
								style: value ? Theme.of(context).textTheme.bodyLarge : null,
							),
						)
					],
				),
			),
		),
	);
}
