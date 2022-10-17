
import 'package:flutter/material.dart';
import 'package:nekodroid/constants/generic_button_type.dart';


class GenericButton extends StatelessWidget {

  final GenericButtonType type;
  final Widget child;
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final bool primary;
  final bool primaryOnForeground;

  const GenericButton.elevated({
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.primary=false,
    this.primaryOnForeground=false,
    super.key,
  }) : type = GenericButtonType.elevated;
  
  const GenericButton.outlined({
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.primary=false,
    this.primaryOnForeground=false,
    super.key,
  }) : type = GenericButtonType.outlined;

  const GenericButton.text({
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.primary=false,
    this.primaryOnForeground=false,
    super.key,
  }) : type = GenericButtonType.text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final buttonStyle = ButtonStyle(
      backgroundColor: primaryOnForeground
        ? null
        : MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.disabled) || !primary
            ? null
            : colorScheme.primary,
        ),
      foregroundColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.disabled) || !primary
          ? null
          : primaryOnForeground
            ? colorScheme.primary
            : colorScheme.onPrimary,
      ),
    );
    switch (type) {
      case GenericButtonType.icon:
      case GenericButtonType.elevated:
        return ElevatedButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: child,
        );
      case GenericButtonType.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: child,
        );
      case GenericButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: child,
        );
    }
  }
}
