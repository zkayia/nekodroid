
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';


/* CONSTANTS */




/* MODELS */




/* PROVIDERS */




/* MISC */




/* WIDGETS */

class GenericButton extends StatelessWidget {

	final bool active;
	final Color? activeColor;
	final Color? inactiveColor;
	final void Function()? onTap;
	final void Function()? onLongPress;
	final IconData? icon;
	final IconData? activeIcon;
	final Widget? child;

	const GenericButton({
		super.key,
		this.active=false,
		this.activeColor,
		this.inactiveColor,
		required this.onTap,
		this.onLongPress,
		required this.icon,
		this.activeIcon,
		this.child,
	});

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		return Material(
			color: theme.colorScheme.surface,
			borderRadius: BorderRadius.circular(kBorderRadMain),
			child: InkWell(
				borderRadius: BorderRadius.circular(kBorderRadMain),
				onTap: onTap,
				onLongPress: onLongPress,
				child: ConstrainedBox(
					constraints: const BoxConstraints(
						minHeight: kMinInteractiveDimension,
						minWidth: kMinInteractiveDimension,
					),
					child: child ?? Icon(
						active ? activeIcon ?? icon : icon,
						color: onTap == null && onLongPress == null
							? theme.disabledColor
							: active
								? activeColor ?? theme.colorScheme.primary
								: inactiveColor,
					),
				),
			),
		);
	}
}
