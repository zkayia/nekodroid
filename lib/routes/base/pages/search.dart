
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/extensions/app_localizations.dart';
import 'package:nekodroid/widgets/labelled_icon.dart';


class SearchPage extends StatelessWidget {

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Card(
        margin: const EdgeInsets.all(kPaddingSecond),
        child: InkWell(
          borderRadius: BorderRadius.circular(kBorderRadMain),
          onTap: () => Navigator.of(context).pushNamed("/base/search"),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: kTopBarHeight),
            child: LabelledIcon.horizontal(
              icon: const Icon(Boxicons.bx_search),
              label: context.tr.search,
            ),
          ),
        ),
      ),
    ],
  );
}
