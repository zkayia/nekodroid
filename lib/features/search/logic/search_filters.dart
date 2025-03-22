import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nekosama/nekosama.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_filters.g.dart';

@riverpod
class SearchFilters extends _$SearchFilters {
  @override
  SearchFiltersState build(SearchFiltersState? initialFilters) => initialFilters ?? const SearchFiltersState();

  Set<T> _toggleInSet<T>(Set<T> set, T element, enabled) => enabled ? set.union({element}) : set.difference({element});

  void setEnum(Enum element, enabled) {
    if (element is NSSources) {
      state = state.copyWith(sources: _toggleInSet(state.sources, element, enabled));
    }
    if (element is NSTypes) {
      state = state.copyWith(types: _toggleInSet(state.types, element, enabled));
    }
    if (element is NSStatuses) {
      state = state.copyWith(statuses: _toggleInSet(state.statuses, element, enabled));
    }
    if (element is NSGenres) {
      state = state.copyWith(genres: _toggleInSet(state.genres, element, enabled));
    }
  }

  void updateScore(RangeValues score) => state = state.copyWith(score: score);

  void updatePopularity(RangeValues popularity) => state = state.copyWith(popularity: popularity);

  void reset() => state = const SearchFiltersState();
}

class SearchFiltersState extends Equatable {
  final Set<NSSources> sources;
  final Set<NSTypes> types;
  final Set<NSStatuses> statuses;
  final Set<NSGenres> genres;
  final RangeValues? score;
  final RangeValues? popularity;

  const SearchFiltersState({
    this.sources = const {},
    this.types = const {},
    this.statuses = const {},
    this.genres = const {},
    this.score,
    this.popularity,
  });

  bool get isEmpty =>
      sources.isEmpty && types.isEmpty && statuses.isEmpty && genres.isEmpty && score == null && popularity == null;

  @override
  List<Object?> get props => [sources, types, statuses, genres, score, popularity];

  SearchFiltersState copyWith({
    Set<NSSources>? sources,
    Set<NSTypes>? types,
    Set<NSStatuses>? statuses,
    Set<NSGenres>? genres,
    RangeValues? score,
    RangeValues? popularity,
  }) =>
      SearchFiltersState(
        sources: sources ?? this.sources,
        types: types ?? this.types,
        statuses: statuses ?? this.statuses,
        genres: genres ?? this.genres,
        score: score ?? this.score,
        popularity: popularity ?? this.popularity,
      );
}
