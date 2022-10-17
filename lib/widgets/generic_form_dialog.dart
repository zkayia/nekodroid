
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/constants/form_dialog_type.dart';
import 'package:nekodroid/models/generic_form_dialog_element.dart';
import 'package:nekodroid/widgets/generic_dialog.dart';
import 'package:nekodroid/widgets/labelled_icon.dart';
import 'package:nekodroid/widgets/large_icon.dart';


class GenericFormDialog<T> extends StatefulWidget {

  final FormDialogType type;
  final String title;
  final List<GenericFormDialogElement<T>> elements;
  final String? placeholderLabel;
  final IconData placeholderIcon;
  
  const GenericFormDialog.checkbox({
    required this.title,
    required this.elements,
    this.placeholderLabel,
    this.placeholderIcon=Boxicons.bx_error_circle,
    super.key,
  }) : type = FormDialogType.checkbox;
  
  const GenericFormDialog.radio({
    required this.title,
    required this.elements,
    this.placeholderLabel,
    this.placeholderIcon=Boxicons.bx_error_circle,
    super.key,
  }) : type = FormDialogType.radio;

  @override
  State<GenericFormDialog> createState() => _GenericFormDialogState<T>();
}

class _GenericFormDialogState<T> extends State<GenericFormDialog> {

  late List<T>? _value;

  @override
  void initState() {
    switch (widget.type) {
      case FormDialogType.checkbox:
        _value = [
          ...widget.elements.where((e) => e.selected).map((e) => e.value)
        ];
        break;
      case FormDialogType.radio:
        _value = widget.elements.any((e) => e.selected)
          ? [widget.elements.firstWhere((e) => e.selected).value]
          : null;
        break;
      default:
        _value = null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => GenericDialog(
    title: widget.title,
    onConfirm: (_) => widget.type == FormDialogType.radio
      ? _value?.first
      : _value,
    canAbortConfirm: false,
    child: widget.elements.isEmpty
      ? Center(
        child: LabelledIcon.vertical(
          icon: LargeIcon(widget.placeholderIcon),
          label: widget.placeholderLabel,
        ),
      )
      : SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          physics: kDefaultScrollPhysics,
          itemCount: widget.elements.length,
          padding: const EdgeInsets.all(kPaddingSecond),
          itemBuilder: (context, index) {
            final element = widget.elements.elementAt(index);
            switch (widget.type) {
              case FormDialogType.checkbox:
                return CheckboxListTile(
                  title: Text(element.label),
                  subtitle: element.details == null 
                    ? null
                    : Text(element.details!),
                  value: _value?.contains(element.value),
                  onChanged: (value) {
                    if (value != _value?.contains(element.value)) {
                      setState(
                        () => value!
                          ? _value?.add(element.value)
                          : _value?.remove(element.value),
                      );
                    }
                  },
                );
              case FormDialogType.radio:
                return RadioListTile<T>(
                  title: Text(element.label),
                  subtitle: element.details == null 
                    ? null
                    : Text(element.details!),
                  value: element.value,
                  groupValue: _value?.first,
                  onChanged: (T? value) {
                    if (value != null) {
                      setState(() => _value = [value]);
                    }
                  },
                );
            }
          },
        ),
      ),
  );
}
