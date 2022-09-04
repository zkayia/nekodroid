
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


/* CONSTANTS */

enum _GenericChipType {click, select}


/* MODELS */




/* PROVIDERS */




/* MISC */




/* WIDGETS */

class GenericChip extends StatelessWidget {

  final _GenericChipType _type;
  final String label;
  final void Function() onTap;
  final bool selected;

  const GenericChip.click({
    required this.label,
    required this.onTap,
    super.key,
  }) :
    _type = _GenericChipType.click,
    selected = false;

  const GenericChip.select({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  }) :
    _type = _GenericChipType.select;

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case _GenericChipType.click:
        return TextButton(
          clipBehavior: Clip.hardEdge,
          onPressed: onTap,
          style: const ButtonStyle().copyWith(
            elevation: MaterialStateProperty.all(kDefaultElevation / 8),
            minimumSize: MaterialStateProperty.all(
              const Size(kMinInteractiveDimension, kMinInteractiveDimension / 1.5),
            ),
          ),
          child: SingleLineText.secondary(label),
        );
      case _GenericChipType.select:
        final theme = Theme.of(context);
        return TextButton(
          clipBehavior: Clip.hardEdge,
          onPressed: onTap,
          style: const ButtonStyle().copyWith(
            elevation: MaterialStateProperty.all(
              kDefaultElevation / (selected ? 2 : 8),
            ),
            minimumSize: MaterialStateProperty.all(
              const Size(kMinInteractiveDimension, kMinInteractiveDimension / 1.5),
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
    }
  }
}
