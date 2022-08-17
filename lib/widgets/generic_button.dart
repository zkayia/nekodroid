
import 'package:flutter/material.dart';


/* CONSTANTS */

enum _GenericButtonType {icon, elevated, outlined, text}


/* MODELS */




/* PROVIDERS */




/* MISC */




/* WIDGETS */

class GenericButton extends StatelessWidget {

  final _GenericButtonType _type;
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
  }) : _type = _GenericButtonType.elevated;
  
  const GenericButton.outlined({
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.primary=false,
    this.primaryOnForeground=false,
    super.key,
  }) : _type = _GenericButtonType.outlined;

  const GenericButton.text({
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.primary=false,
    this.primaryOnForeground=false,
    super.key,
  }) : _type = _GenericButtonType.text;

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
    switch (_type) {
      case _GenericButtonType.icon:
      case _GenericButtonType.elevated:
        return ElevatedButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: child,
        );
      case _GenericButtonType.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: child,
        );
      case _GenericButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: child,
        );
    }
  }
}
