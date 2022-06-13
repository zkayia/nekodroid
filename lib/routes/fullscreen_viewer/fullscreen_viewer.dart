
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/generic_route.dart';


class FullscreenViewerRoute extends StatelessWidget {

	const FullscreenViewerRoute({super.key});

	@override
	Widget build(BuildContext context) => GenericRoute(
		body: Padding(
			padding: const EdgeInsets.all(kPaddingMain),
			child: Center(
				child: ModalRoute.of(context)!.settings.arguments as Widget,
			),
		),
	);
}
