
import 'package:flutter_riverpod/flutter_riverpod.dart';


final selectableFiltersProvider = StateNotifierProvider.autoDispose<
	_SelectableFiltersProviderNotifier,
	Set
>(
	(ref) => _SelectableFiltersProviderNotifier(),
);

class _SelectableFiltersProviderNotifier extends StateNotifier<Set> {

	_SelectableFiltersProviderNotifier() : super({});

	void add(element) => state = {...state, element};

	void remove(element) => state = {...state.where((e) => e != element)};

	void toggle(element) => state.contains(element)
		? remove(element)
		: add(element);
}
