
import 'package:flutter/material.dart';


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
