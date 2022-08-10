
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/labelled_icon.dart';
import 'package:nekodroid/widgets/large_icon.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


enum _DialogType {radio}

@immutable
class GenericDialogElement<T> {

	final String label;
	final T value;
	final bool selected;

	const GenericDialogElement({
		required this.label,
		required this.value,
		this.selected=false,
	});
}

class GenericDialog<T> extends StatefulWidget {

	final _DialogType _type;
	final String? title;
	final List<GenericDialogElement<T>> children;
	final String? placeholderLabel;
	final IconData placeholderIcon;
	
	const GenericDialog.radio({
		super.key,
		this.title,
		required this.children,
		this.placeholderLabel,
		this.placeholderIcon=Boxicons.bx_error_circle,
	}) : _type = _DialogType.radio;

	@override
	State<GenericDialog> createState() => _GenericDialogState<T>();
}

class _GenericDialogState<T> extends State<GenericDialog> {

	late T? _value;

	@override
  void initState() {
		switch (widget._type) {
			case _DialogType.radio:
	    	_value = widget.children.any((e) => e.selected)
					? widget.children.firstWhere((e) => e.selected).value
					: null;
		}
    super.initState();
  }

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		return AlertDialog(
			title: SingleLineText(widget.title ?? ""),
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
								onPressed: () => Navigator.of(context).pop(_value),
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
			content: widget.children.isEmpty
				? Center(
					child: LabelledIcon.vertical(
						icon: LargeIcon(widget.placeholderIcon),
						label: widget.placeholderLabel,
					),
				)
				: SizedBox.fromSize(
					size: const Size.square(double.maxFinite),
					child: ListView.builder(
						shrinkWrap: true,
						physics: kDefaultScrollPhysics,
						itemCount: widget.children.length,
						padding: const EdgeInsets.all(kPaddingSecond),
						itemBuilder: (context, index) {
							final element = widget.children.elementAt(index);
							if (widget._type == _DialogType.radio) {
								return RadioListTile<T>(
									title: SingleLineText(element.label),
									value: element.value,
									groupValue: _value,
									onChanged: (T? value) => setState(() {
										if (value != null) {
											_value = value;
										}
									}),
								);
							}
							return const SizedBox();
						},
					),
				),
		);
	}
}
