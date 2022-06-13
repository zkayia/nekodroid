
import 'package:flutter/material.dart';


class ListTileIcon extends StatelessWidget {

	final bool _useAccent;
	final IconData icon;

	const ListTileIcon(this.icon, {super.key}) : _useAccent = false;

	const ListTileIcon.accent(this.icon, {super.key}) : _useAccent = true;

	@override
	Widget build(BuildContext context) => SizedBox(
		height: double.infinity,
		child: Icon(
			icon,
			color: _useAccent
				? Theme.of(context).colorScheme.secondary
				: null,
		),
	);
}
