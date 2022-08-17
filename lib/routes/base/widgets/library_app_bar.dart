
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/app_localizations.dart';
import 'package:nekodroid/widgets/labelled_icon.dart';


class LibraryAppBar extends StatelessWidget {

  const LibraryAppBar({super.key});

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.all(kPaddingSecond),
    child: TabBar(
      splashBorderRadius: BorderRadius.circular(kBorderRadMain),
      tabs: [
        Tab(
          height: kTopBarHeight - kTabbarIndicatorSize,
          child: FittedBox(
            child: LabelledIcon.horizontal(
              icon: const Icon(Boxicons.bx_history),
              label: context.tr.libraryHistory,
            ),
          ),
        ),
        Tab(
          height: kTopBarHeight - kTabbarIndicatorSize,
          child: FittedBox(
            child: LabelledIcon.horizontal(
              icon: const Icon(Boxicons.bxs_heart),
              label: context.tr.libraryFavorites,
            ),
          ),
        ),
      ],
    ),
  );
}
