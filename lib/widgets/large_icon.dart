
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';


class LargeIcon extends Icon {
	
	const LargeIcon(
		super.icon,
		{
			super.key,
			super.color,
			super.semanticLabel,
			super.shadows,
			super.textDirection,
		}
	) : super(size: kLargeIconSize);
}
