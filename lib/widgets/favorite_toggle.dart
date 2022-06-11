
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/constants.dart';
import 'package:nekodroid/provider/favorites.dart';
import 'package:nekosama_dart/nekosama_dart.dart';


class FavoriteToggle extends ConsumerWidget {

	final NSAnime anime;
	final bool boxOnly;

	const FavoriteToggle({
		required this.anime,
		this.boxOnly=false,
		Key? key,
	}) : super(key: key);

	@override
	Widget build(BuildContext context, WidgetRef ref) => InkWell(
		borderRadius: BorderRadius.circular(kBorderRadMain),
		child: ConstrainedBox(
			constraints: const BoxConstraints(
				minHeight: kMinInteractiveDimension,
				minWidth: kMinInteractiveDimension,
			),
			child: (
				boxOnly
					? ref.watch(favoritesProvider.notifier).isFavoritedBox(anime.url)
					: ref.watch(favoritesProvider).containsKey(anime.url)
			)
				? const Icon(
					Boxicons.bxs_heart,
					color: Colors.red,
				)
				: const Icon(Boxicons.bx_heart),
		),
		onTap: () => boxOnly
			? ref.read(favoritesProvider.notifier).toggleFavBoxOnly(
				anime.url,
				DateTime.now(),
				anime,
			)
			: ref.read(favoritesProvider.notifier).toggleFav(
				anime.url,
				DateTime.now(),
				anime,
			),
	);
}
