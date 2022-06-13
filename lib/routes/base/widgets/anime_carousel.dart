
import 'dart:math';

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/anime_card.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class AnimeCarousel extends StatelessWidget {

	final String title;
	final Object? titleHeroTag;
	final List<AnimeCard> items;
	final void Function()? onMoreTapped;

	const AnimeCarousel({
		required this.title,
		this.titleHeroTag,
		required this.items,
		this.onMoreTapped,
		super.key,
	});

	@override
	Widget build(BuildContext context) {
		final titleEl = SingleLineText(
			title,
			style: Theme.of(context).textTheme.titleLarge,
		);
		final mediaQueryData = MediaQuery.of(context);
		return LimitedBox(
			maxHeight: max(
				kAnimeCarouselBaseHeight * mediaQueryData.textScaleFactor,
				(mediaQueryData.size.height - kBottomBarHeight - kPaddingSecond * 3) / 3,
			),
			child: Column(
				mainAxisSize: MainAxisSize.max,
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					InkWell(
						onTap: onMoreTapped,
						borderRadius: BorderRadius.circular(kBorderRadMain),
						child: Padding(
							padding: const EdgeInsets.symmetric(horizontal: kPaddingMain),
							child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								children: [
									Expanded(
										child: titleHeroTag == null
											? titleEl
											: Hero(
												tag: titleHeroTag!,
												child: titleEl,
											),
									),
									const SizedBox(width: kPaddingSecond),
									IconButton(
										icon: const Icon(Boxicons.bx_chevron_right),
										onPressed: onMoreTapped,
									),
								],
							),
						),
					),
					const SizedBox(height: kPaddingSecond),
					Expanded(
						child: ShaderMask(
							shaderCallback: (Rect rect) => const LinearGradient(
								end: Alignment.center,
								tileMode: TileMode.mirror,
								colors: kShadowColors,
								stops: kShadowStops,
							).createShader(rect),
							blendMode: BlendMode.dstOut,
							child: ListView.separated(
								padding: const EdgeInsets.symmetric(horizontal: kPaddingMain),
								shrinkWrap: true,
								physics: kDefaultScrollPhysics,
								scrollDirection: Axis.horizontal,
								itemCount: items.length,
								itemBuilder: (context, index) => items.elementAt(index),
								separatorBuilder: (context, index) => const SizedBox(width: kPaddingSecond),
							),
						),
					),
				],
			),
		);
	}
}
