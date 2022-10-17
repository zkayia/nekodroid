
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/build_context.dart';
import 'package:nekodroid/extensions/range_values.dart';
import 'package:nekodroid/routes/base.search/providers/range_values.dart';
import 'package:nekodroid/routes/base.search/providers/selectable_filters.dart';
import 'package:nekodroid/routes/base.search/widgets/filters_dialog_selectable.dart';
import 'package:nekodroid/routes/base.search/widgets/filters_dialog_title.dart';
import 'package:nekodroid/widgets/generic_button.dart';
import 'package:nekodroid/widgets/generic_dialog.dart';
import 'package:nekosama/nekosama.dart';


class FiltersDialog extends ConsumerWidget {

  const FiltersDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final miscBox = Hive.box("misc-data");
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingMain,
        vertical: kPaddingSecond,
      ),
      physics: kDefaultScrollPhysics,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FiltersDialogTitle(
            text: context.tr.type,
            infoText: "${
              ref.watch(selectableFiltersProv).whereType<NSTypes>().length
            }/${NSTypes.values.length}",
          ),
          FiltersDialogSelectable(
            translate: context.tr.types,
            values: NSTypes.values,
          ),
          FiltersDialogTitle(
            text: context.tr.status,
            infoText: "${
              ref.watch(selectableFiltersProv).whereType<NSStatuses>().length
            }/${NSStatuses.values.length}",
          ),
          FiltersDialogSelectable(
            translate: context.tr.statuses,
            values: NSStatuses.values,
          ),
          FiltersDialogTitle(
            text: context.tr.genre,
            infoText: "${
              ref.watch(selectableFiltersProv).whereType<NSGenres>().length
            }/${NSGenres.values.length}",
          ),
          FiltersDialogSelectable(
            translate: context.tr.genres,
            values: NSGenres.values,
          ),
          FiltersDialogTitle(
            text: context.tr.score,
            infoText: ref.watch(scoreFilterProv).prettyToString(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kPaddingMain,
            ),
            child: RangeSlider(
              values: ref.watch(scoreFilterProv),
              max: 5,
              min: 0,
              onChanged: ref.read(scoreFilterProv.notifier).updateValue,
            ),
          ),
          FiltersDialogTitle(
            text: context.tr.popularity,
            infoText: ref.watch(popularityFilterProv).prettyToString(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kPaddingMain,
            ),
            child: RangeSlider(
              values: ref.watch(popularityFilterProv),
              max: miscBox.get("searchdb-highest-popularity"),
              min: miscBox.get("searchdb-lowest-popularity"),
              onChanged: ref.read(popularityFilterProv.notifier).updateValue,
            ),
          ),
          const SizedBox(height: kPaddingMain),
          Row(
            children: [
              Expanded(
                child: GenericButton.elevated(
                  onPressed: () async => 
                    showDialog<bool>(
                      context: context,
                      builder: (context) => GenericDialog.confirm(
                        title: context.tr.searchFiltersResetConfirm,
                        child: Text(context.tr.searchFiltersResetConfirmDesc),
                      ),
                    ).then((result) {
                      if (result ?? false) {
                        ref
                          ..read(selectableFiltersProv.notifier).reset()
                          ..read(scoreFilterProv.notifier).reset()
                          ..read(popularityFilterProv.notifier).reset();
                      }
                    }),
                  child: const Text("Reset"), //TODO: tr
                ),
              ),
              const SizedBox(width: kPaddingMain),
              Expanded(
                child: GenericButton.elevated(
                  onPressed: Navigator.of(context).pop,
                  child: const Text("Close"), //TODO: tr
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
