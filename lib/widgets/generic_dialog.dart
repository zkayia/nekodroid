
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/labelled_icon.dart';
import 'package:nekodroid/widgets/large_icon.dart';
import 'package:nekodroid/widgets/overflow_text.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


/* CONSTANTS */

enum _DialogType {custom, checkbox, radio}


/* MODELS */

@immutable
class GenericDialogElement<T> {

	final String label;
	final T value;
	final String? details;
	final bool selected;

	const GenericDialogElement({
		required this.label,
		required this.value,
		this.details,
		this.selected=false,
	});
}


/* PROVIDERS */




/* MISC */




/* WIDGETS */

class GenericDialog<T> extends StatefulWidget {

	final _DialogType _type;
	final List<Widget>? children;
	final List<GenericDialogElement<T>>? elements;
	final String? title;
	final String? placeholderLabel;
	final IconData placeholderIcon;
	
	const GenericDialog({
		required this.children,
		this.title,
		this.placeholderLabel,
		this.placeholderIcon=Boxicons.bx_error_circle,
		super.key,
	}) :
		_type = _DialogType.custom,
		elements = null;

	const GenericDialog.checkbox({
		required this.elements,
		this.title,
		this.placeholderLabel,
		this.placeholderIcon=Boxicons.bx_error_circle,
		super.key,
	}) :
		_type = _DialogType.checkbox,
		children = null;
	
	const GenericDialog.radio({
		required this.elements,
		this.title,
		this.placeholderLabel,
		this.placeholderIcon=Boxicons.bx_error_circle,
		super.key,
	}) :
		_type = _DialogType.radio,
		children = null;

	@override
	State<GenericDialog> createState() => _GenericDialogState<T>();
}

class _GenericDialogState<T> extends State<GenericDialog> {

	late List<T>? _value;

	@override
	void initState() {
		switch (widget._type) {
			case _DialogType.checkbox:
				_value = [
					...widget.elements!.where((e) => e.selected).map((e) => e.value)
				];
				break;
			case _DialogType.radio:
				_value = widget.elements!.any((e) => e.selected)
					? [widget.elements!.firstWhere((e) => e.selected).value]
					: null;
				break;
			case _DialogType.custom:
			default:
				_value = null;
		}
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		return AlertDialog(
			title: widget.title == null
				? null
				: SingleLineText(widget.title!),
			actionsAlignment: MainAxisAlignment.center,
			actions: [
				Row(
					children: [
						Expanded(
							child: TextButton(
								onPressed: () => Navigator.of(context).pop(),
								child: const SingleLineText("Cancel"),
							),
						),
						const SizedBox(width: kPaddingMain),
						Expanded(
							child: TextButton(
								style: theme.textButtonTheme.style?.copyWith(
									backgroundColor: MaterialStateProperty.all(theme.colorScheme.primary),
									foregroundColor: MaterialStateProperty.all(theme.colorScheme.onPrimary),
								),
								onPressed: () => Navigator.of(context).pop(
									widget._type == _DialogType.radio
										? _value?.first
										: _value,
								),
								child: const SingleLineText("Ok"),
							),
						),
					],
				)
			],
			contentPadding: const EdgeInsets.symmetric(
				horizontal: kPaddingMain,
				vertical: kPaddingSecond,
			),
			content: (
				widget._type == _DialogType.custom
					? widget.children
					: widget.elements
			)?.isEmpty ?? true
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
						itemCount: widget._type == _DialogType.custom
							? widget.children!.length
							: widget.elements!.length,
						padding: const EdgeInsets.all(kPaddingSecond),
						itemBuilder: (context, index) {
							if (widget._type == _DialogType.custom) {
								return widget.children!.elementAt(index);
							}
							final element = widget.elements!.elementAt(index);
							switch (widget._type) {
								case _DialogType.checkbox:
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
								case _DialogType.radio:
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
								default:
									return const SizedBox.shrink();
							}
						},
					),
				),
		);
	}
}
