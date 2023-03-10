part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnActivateManualMarkerEvent extends SearchEvent {}

class OnDeActivateManualMarkerEvent extends SearchEvent {}

class OnNewPlacesFoundEvent extends SearchEvent {
  final List<Features> places;

  const OnNewPlacesFoundEvent(this.places);
}

class AddToHistoryEvent extends SearchEvent {
  final Features place;
  const AddToHistoryEvent(this.place);
}
