
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/anime_title.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class AnimeCard extends StatelessWidget {

	final String? badge;
	final Widget image;
	final bool isEpisode;
	final String? label;
	final void Function()? onImageTap;
	final void Function()? onLabelTap;

	const AnimeCard({
		this.badge,
		required this.image,
		this.isEpisode=false,
		this.label,
		this.onImageTap,
		this.onLabelTap,
		super.key,
	});

	@override
	Widget build(BuildContext context) => AspectRatio(
		aspectRatio: 5 / 7,
		child: Column(
			children: [
				Expanded(
					child: ClipRRect(
						borderRadius: BorderRadius.circular(kBorderRadMain),
						child: InkWell(
							onTap: onImageTap,
							child: Stack(
								fit: StackFit.expand,
								alignment: Alignment.center,
								children: [
									image,
									if (isEpisode)
										Container(
											color: kShadowThumbWithIcon,
											child: const Center(
												child: Icon(
													Boxicons.bx_play,
													color: kOnImageColor,
												),
											),
										),
									if (badge != null)
										Align(
											alignment: AlignmentDirectional.bottomEnd,
											child: ClipRRect(
												borderRadius: const BorderRadius.only(
													topLeft: Radius.circular(kBorderRadMain),
												),
												child: Material(
													color: kAnimeCardBadgeShadow,
													child: Padding(
														padding: kAnimeCardBadgeTextPadding,
														child: FittedBox(
															child: SingleLineText(
																badge ?? "",
																style: Theme.of(context).textTheme.bodyMedium?.copyWith(
																	color: kAnimeCardBadgeColor,
																),
															),
														),
													),
												),
											),
										),
								],
							),
						),
					),
				),
				if (label != null)
					InkWell(
						onTap: onLabelTap,
						child: AnimeTitle(label ?? "", isExtended: false),
					),
			],
		),
	);
}
