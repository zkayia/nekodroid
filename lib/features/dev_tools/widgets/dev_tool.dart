import 'package:flutter/material.dart';

class DevTool extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Object? value;
  final bool valueIsMissing;
  final void Function()? onTap;
  final bool _hasValue;

  const DevTool({
    required this.title,
    this.trailing,
    this.onTap,
    super.key,
  })  : _hasValue = false,
        value = null,
        valueIsMissing = false;

  const DevTool.withValue({
    required this.title,
    this.trailing,
    this.value,
    this.valueIsMissing = false,
    this.onTap,
    super.key,
  }) : _hasValue = true;

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(title),
        subtitle: _hasValue ? Text(valueIsMissing ? "($value)" : "[$value]") : null,
        onTap: onTap,
        trailing: trailing,
      );
}
