
import 'package:flutter/material.dart';
import 'package:nekodroid/routes/base/widgets/library_app_bar.dart';
import 'package:nekodroid/routes/base/widgets/library_tabview.dart';


class LibraryPage extends StatelessWidget {

	const LibraryPage({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) => DefaultTabController(
		length: 2,
		child: Stack(
			children: const [
				LibraryTabview(),
				Align(
					alignment: Alignment.topCenter,
					child: LibraryAppBar(),
				),
			],
		),
	);
}
