
import 'package:android_intent_plus/android_intent.dart';
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/helpers/anime_data_text.dart';
import 'package:nekodroid/widgets/anime_card.dart';
import 'package:nekodroid/widgets/anime_title.dart';
import 'package:nekodroid/widgets/favorite_toggle.dart';
import 'package:nekodroid/widgets/generic_image.dart';
import 'package:nekodroid/widgets/single_line_text.dart';
import 'package:nekosama_dart/nekosama_dart.dart';
import 'package:share_plus/share_plus.dart';


class AnimePageHeader extends StatelessWidget {

	final NSAnime anime; 

	const AnimePageHeader(this.anime, {super.key});

	@override
	Widget build(BuildContext context) {
		final thumbnail = Hero(
			tag: "anime_thumbnail",
			child: GenericImage(anime.thumbnail),
		);
		return LimitedBox(
			maxHeight: kAnimePageGroupMaxHeight,
			child: Row(
				children: [
					AnimeCard(
						image: thumbnail,
						onImageTap: () => Navigator.of(context).pushNamed(
							"/fullscreen_viewer",
							arguments: InteractiveViewer(
								child: thumbnail,
							),
						),
					),
					const SizedBox(width: kPaddingSecond),
					Expanded(
						child: Column(
							mainAxisAlignment: MainAxisAlignment.spaceEvenly,
							crossAxisAlignment: CrossAxisAlignment.center,
							children: [
								Flexible(
									child: FittedBox(
										child: SingleLineText.secondary(
											animeDataText(anime),
											textAlign: TextAlign.center,
										),
									),
								),
								Flexible(
									flex: 2,
									child: AnimeTitle.bold(
										anime.title,
										textAlign: TextAlign.center,
									),
								),
								Flexible(
									child: Row(
										mainAxisAlignment: MainAxisAlignment.spaceEvenly,
										children: [
											Material(
												color: Theme.of(context).colorScheme.background,
												borderRadius: BorderRadius.circular(kBorderRadMain),
												child: InkWell(
													borderRadius: BorderRadius.circular(kBorderRadMain),
													child: ConstrainedBox(
														constraints: const BoxConstraints(
															minHeight: kMinInteractiveDimension,
															minWidth: kMinInteractiveDimension,
														),
														child: const Icon(Boxicons.bx_link_external),
													),
													onTap: () => AndroidIntent(
														action: "action_view",
														data: anime.url.toString(),
													).launch(),
												),
											),
											Material(
												color: Theme.of(context).colorScheme.background,
												borderRadius: BorderRadius.circular(kBorderRadMain),
												child: InkWell(
													borderRadius: BorderRadius.circular(kBorderRadMain),
													child: ConstrainedBox(
														constraints: const BoxConstraints(
															minHeight: kMinInteractiveDimension,
															minWidth: kMinInteractiveDimension,
														),
														child: const Icon(Boxicons.bx_share_alt),
													),
													onTap: () => Share.share(
														anime.url.toString(),
														subject: anime.title,
													),
												),
											),
											Material(
												color: Theme.of(context).colorScheme.background,
												borderRadius: BorderRadius.circular(kBorderRadMain),
												child: FavoriteToggle(anime: anime),
											),
										],
									),
								),
							],
						),
					)
				],
			),
		);
	}
}
