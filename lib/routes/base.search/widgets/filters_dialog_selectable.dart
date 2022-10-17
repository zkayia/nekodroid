
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/routes/base.search/providers/selectable_filters.dart';
import 'package:nekodroid/widgets/chip_wrap.dart';
import 'package:nekodroid/widgets/generic_chip.dart';


class FiltersDialogSelectable extends ConsumerWidget {

  final List<Enum> values;
  final String Function(String) translate;

  const FiltersDialogSelectable({
    required this.values,
    required this.translate,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => ChipWrap(
    genres: [
      ...values.map(
        (e) => GenericChip.select(
          label: translate.call(e.name),
          selected: ref.watch(selectableFiltersProv).contains(e),
          onTap: () =>
            ref.read(selectableFiltersProv.notifier).toggle(e),
        ),
      ),
    ],
  );
}
