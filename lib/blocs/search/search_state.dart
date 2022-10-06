part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool displayManualMarker;
  final List<Features> places;
  final List<Features> history;

  const SearchState(
      {this.displayManualMarker = false,
      this.places = const [],
      this.history = const []});

  SearchState copyWith({
    bool? displayManualMarker,
    List<Features>? places,
    List<Features>? history,
  }) =>
      SearchState(
        displayManualMarker: displayManualMarker ?? this.displayManualMarker,
        places: places ?? this.places,
        history: history ?? this.history,
      );

  @override
  List<Object> get props => [displayManualMarker, places, history];
}
