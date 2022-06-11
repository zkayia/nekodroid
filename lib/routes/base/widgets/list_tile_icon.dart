
import 'package:flutter/material.dart';


class ListTileIcon extends StatelessWidget {

	final bool _useAccent;
	final IconData icon;

	const ListTileIcon(this.icon, {Key? key}) :
		_useAccent = false,
		super(key: key);

	const ListTileIcon.accent(this.icon, {Key? key}) :
		_useAccent = true,
		super(key: key);

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
