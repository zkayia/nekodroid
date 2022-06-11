
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekodroid/routes/anime/providers/blur_thumbs.dart';
import 'package:nekodroid/widgets/generic_image.dart';


class EpisodeThumbnail extends ConsumerWidget {

	final Uri imageUrl;
	
	const EpisodeThumbnail(this.imageUrl, {Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context, WidgetRef ref) => ConstrainedBox(
		constraints: const BoxConstraints(
			maxWidth: kEpisodeThumbnailMaxWidth,
		),
		child: AspectRatio(
			aspectRatio: 16 / 9,
			child: ClipRRect(
				borderRadius: BorderRadius.circular(kBorderRadMain),
				child: GenericImage(
					imageUrl,
					childBuilder: (context, child) {
						final blurThumbsSigma = ref.watch(
							settingsProvider.select((value) => value.blurThumbsSigma),
						);
						return ref.read(blurThumbsProvider)
							? ImageFiltered(
								imageFilter: ImageFilter.blur(
									sigmaX: blurThumbsSigma,
									sigmaY: blurThumbsSigma,
								),
								child: child,
							)
							: child;
					},
				),
			),
		),
	);
}
