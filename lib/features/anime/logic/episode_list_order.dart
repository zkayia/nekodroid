import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'episode_list_order.g.dart';

@riverpod
class EpisodeListOrder extends _$EpisodeListOrder {
  @override
  EpisodeListOrderState build() => EpisodeListOrderState.desc;

  void invert() => state = state.next;
}

enum EpisodeListOrderState {
  asc,
  desc;

  EpisodeListOrderState get next => EpisodeListOrderState.values.elementAt((index + 1) % EpisodeListOrderState.values.length);
}
