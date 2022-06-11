
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekodroid/provider/settings.dart';
import 'package:nekosama_dart/nekosama_dart.dart';


final lazyLoadProvider = StateNotifierProvider.autoDispose.family<
	_LazyLoadProviderNotifier,
	List<NSEpisode>,
	List<NSEpisode>
>(
	(ref, episodes) => _LazyLoadProviderNotifier(
		episodes,
		ref.watch(settingsProvider).lazyLoadItemCount,
	),
);

class _LazyLoadProviderNotifier extends StateNotifier<List<NSEpisode>> {

	final List<NSEpisode> _episodes;
	final int _lazyLoadItemCount;

	_LazyLoadProviderNotifier(
		this._episodes,
		this._lazyLoadItemCount,
	) : super(
		[..._episodes.take(_lazyLoadItemCount)],
	);

	void loadMore() => state = [
		..._episodes.take(state.length + _lazyLoadItemCount),
	];
}
