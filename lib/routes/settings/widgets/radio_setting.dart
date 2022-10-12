
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/generic_form_dialog.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class RadioSetting<T> extends StatelessWidget {
  
  final String title;
  final String? subtitle;
  final List<GenericFormDialogElement<T>> elements;
  final bool enabled;
  final void Function(T v)? onChanged;

  const RadioSetting({
    required this.title,
    required this.elements,
    required this.onChanged,
    this.subtitle,
    this.enabled=true,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: kPaddingSecond,
    ),
    title: SingleLineText(title),
    subtitle: subtitle == null ? null : Text(subtitle!),
    trailing: const Icon(Boxicons.bxs_chevron_right),
    onTap: !enabled || onChanged == null
      ? null
      : () async {
        final result = await showDialog<T>(
          context: context,
          builder: (context) => GenericFormDialog<T>.radio(
            title: title,
            elements: elements,
          ),
        );
        if (result != null) {
          onChanged!(result);
        }
      },
  );
}
