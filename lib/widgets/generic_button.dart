
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';


/* CONSTANTS */




/* MODELS */




/* PROVIDERS */




/* MISC */




/* WIDGETS */

class GenericButton extends StatelessWidget {

	final IconData? icon;
	final void Function()? onTap;
	final void Function()? onLongPress;
	final bool active;
	final IconData? activeIcon;
	final Color? activeColor;
	final Color? inactiveColor;
	final Widget? child;

	const GenericButton({
		required this.icon,
		required this.onTap,
		this.onLongPress,
		this.active=false,
		this.activeIcon,
		this.activeColor,
		this.inactiveColor,
		this.child,
		super.key,
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
