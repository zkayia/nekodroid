
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/generic_route.dart';


class FullscreenViewerRoute extends StatelessWidget {

  const FullscreenViewerRoute({super.key});

  @override
  Widget build(BuildContext context) => GenericRoute(
    body: ConstrainedBox(
      constraints: BoxConstraints.tight(MediaQuery.of(context).size),
      child: SingleChildScrollView(
        physics: kDefaultScrollPhysics,
        padding: const EdgeInsets.only(
          top: kPaddingSecond,
          left: kPaddingSecond,
          right: kPaddingSecond,
          bottom: kPaddingSecond + kFabSize + 16,
        ),
        child: ModalRoute.of(context)!.settings.arguments as Widget,
      ),
    ),
  );
}
