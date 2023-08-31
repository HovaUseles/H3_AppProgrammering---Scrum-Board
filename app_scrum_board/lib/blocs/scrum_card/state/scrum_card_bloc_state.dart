
import '../../../models/_models.dart';

enum CrudStates { initial, loading, complete, error }

class ScrumCardCrudState {
  final CrudStates state;

  ScrumCardCrudState({
    required this.state
  });
}

class DisplayScrumCards extends ScrumCardCrudState {
  final List<ScrumCard>? scrumCards;

  DisplayScrumCards({
    required CrudStates state,
    this.scrumCards
    }) : super(state: state);
}

class DisplayScrumCard extends ScrumCardCrudState {
  final ScrumCard? scrumCard;

  DisplayScrumCard({
    required CrudStates state,
    this.scrumCard
    }) : super(state: state);
}