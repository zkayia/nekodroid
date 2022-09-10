
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/generic_dialog.dart';
import 'package:nekodroid/widgets/labelled_icon.dart';
import 'package:nekodroid/widgets/large_icon.dart';
import 'package:nekodroid/widgets/overflow_text.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


/* CONSTANTS */

enum _FormDialogType {checkbox, radio}


/* MODELS */

@immutable
class GenericFormDialogElement<T> {

  final String label;
  final T value;
  final String? details;
  final bool selected;

  const GenericFormDialogElement({
    required this.label,
    required this.value,
    this.details,
    this.selected=false,
  });
}


/* PROVIDERS */




/* MISC */




/* WIDGETS */

class GenericFormDialog<T> extends StatefulWidget {

  final _FormDialogType _type;
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
  }) : _type = _FormDialogType.checkbox;
  
  const GenericFormDialog.radio({
    required this.title,
    required this.elements,
    this.placeholderLabel,
    this.placeholderIcon=Boxicons.bx_error_circle,
    super.key,
  }) : _type = _FormDialogType.radio;

  @override
  State<GenericFormDialog> createState() => _GenericFormDialogState<T>();
}

class _GenericFormDialogState<T> extends State<GenericFormDialog> {

  late List<T>? _value;

  @override
  void initState() {
    switch (widget._type) {
      case _FormDialogType.checkbox:
        _value = [
          ...widget.elements.where((e) => e.selected).map((e) => e.value)
        ];
        break;
      case _FormDialogType.radio:
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
    cancelValue: null,
    okValue: widget._type == _FormDialogType.radio
      ? _value?.first
      : _value,
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
            switch (widget._type) {
              case _FormDialogType.checkbox:
                return CheckboxListTile(
                  title: SingleLineText(element.label),
                  subtitle: element.details == null 
                    ? null
                    : OverflowText(element.details!),
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
              case _FormDialogType.radio:
                return RadioListTile<T>(
                  title: SingleLineText(element.label),
                  subtitle: element.details == null 
                    ? null
                    : OverflowText(element.details!),
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
