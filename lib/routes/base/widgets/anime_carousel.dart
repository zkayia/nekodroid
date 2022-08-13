
import 'dart:math';

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/widgets/anime_card.dart';
import 'package:nekodroid/widgets/single_line_text.dart';


class AnimeCarousel extends StatelessWidget {

	final String title;
	final List<AnimeCard> items;
	final Object? titleHeroTag;
	final void Function()? onMoreTapped;

	const AnimeCarousel({
		required this.title,
		required this.items,
		this.titleHeroTag,
		this.onMoreTapped,
		super.key,
	});

	@override
	Widget build(BuildContext context) {
		final titleLarge = Theme.of(context).textTheme.titleLarge;
		final titleEl = SingleLineText(
			title,
			style: titleLarge,
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
					Padding(
						padding: const EdgeInsets.symmetric(horizontal: kPaddingMain / 2),
						child: InkWell(
							onTap: onMoreTapped,
							borderRadius: BorderRadius.circular(kBorderRadMain),
							child: Padding(
								padding: const EdgeInsets.symmetric(horizontal: kPaddingMain / 2),
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
											onPressed: null,
											icon: Icon(
												Boxicons.bxs_chevron_right,
												color: titleLarge?.color,
											),
										),
									],
								),
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
