
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/widgets/generic_dialog.dart';


final _inputControllerProv = StateProvider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);

final _errorTextProv = StateProvider.autoDispose<String?>(
  (ref) => null,
);

class GenericInputDialog extends ConsumerWidget {

  final String title;
  final String? hintText;
  final String? Function(String? value, BuildContext context)? validator;
  
  const GenericInputDialog({
    required this.title,
    this.hintText,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => GenericDialog(
    title: title,
    onConfirm: (context) => _exit(context, ref),
    child: TextFormField(
      controller: ref.watch(_inputControllerProv),
      autofocus: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator != null
        ? (v) {
          ref.refresh(_errorTextProv.notifier);
          return validator!(v?.trim(), context);
        }
        : null,
      decoration: InputDecoration(
        hintText: hintText == null ? null : " $hintText",
        helperText: " ",
        errorText: ref.watch(_errorTextProv),
      ),
      onFieldSubmitted: (_) => _exit(context, ref, true),
    ),
  );

  String? _exit(BuildContext context, WidgetRef ref, [bool exit=false]) {
    final text = ref.read(_inputControllerProv).text.trim();
    final validatorResult = validator?.call(text, context);
    ref.read(_errorTextProv.notifier).update((_) => validatorResult);
    if (validatorResult != null) {
      return null;
    }
    if (exit) {
      Navigator.of(context).pop(text);
    }
    return text;
  }
}
