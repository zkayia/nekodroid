
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/overflow_text.dart';


class LabelledIcon extends StatelessWidget {

	final Axis _axis;
	final Widget icon;
	final String? label;

	const LabelledIcon.horizontal({
		required this.icon,
		this.label,
		super.key,
	}) : _axis = Axis.horizontal;
	const LabelledIcon.vertical({
		required this.icon,
		this.label,
		super.key,
	}) : _axis = Axis.vertical;

	@override
	Widget build(BuildContext context) => Flex(
		direction: _axis,
		mainAxisAlignment: MainAxisAlignment.center,
		children: [
			icon,
			if (label != null)
				...[
					if (_axis == Axis.horizontal)
						const SizedBox(width: kPaddingSecond)
					else
						const SizedBox(height: kPaddingSecond),
					OverflowText(
						label!,
						textAlign: TextAlign.center,
					),
				],
		],
	);
}
