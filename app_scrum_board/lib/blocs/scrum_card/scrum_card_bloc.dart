import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data_access/scrum_card_data_handler.dart';
import '../../models/_models.dart';
import '../../services/locators.dart';
import 'event/scrum_card_bloc_event.dart';
import 'state/scrum_card_bloc_state.dart';


class ScrumCardCrudBloc extends Bloc<ScrumCardCrudEvent, ScrumCardCrudState> {

  Future<void> _tryEmitScrumCards(emit) async {
    ScrumCardDataHandler handler = locator<ScrumCardDataHandler>(); // Inject handler

    // Try emitting updated ScrumCard list
    emit(DisplayScrumCard(state: CrudStates.loading)); // Emit loading state
    try {
      List<ScrumCard> items = await handler.getAll();
      emit(DisplayScrumCards(
          state: CrudStates.complete, 
          scrumCards: items)
      );
    }
    catch(ex) {
      emit(DisplayScrumCards(state: CrudStates.error)); // Emit error state
    }
  }

  ScrumCardCrudBloc() : super(DisplayScrumCards(state: CrudStates.initial)) {

    // Create event handler
    on<CreateScrumCard>((event, emit) async {
      ScrumCardDataHandler handler = locator<ScrumCardDataHandler>(); // Inject handler
      // Create the new ScrumCard in data source
      await handler.create(ScrumCard(
        index: event.index,
        title: event.title,
        content: event.content,
        scrumColumn: event.scrumColumn
      ));
      
      await _tryEmitScrumCards(emit);
    });

    // Edit event handler
    on<EditScrumCard>((event, emit) async {
      ScrumCardDataHandler handler = locator<ScrumCardDataHandler>(); // Inject handler
      await handler.edit(event.scrumCard);
    });

    // Get all event handler
    on<FetchScrumCards>((event, emit) async {
      emit(DisplayScrumCards(state: CrudStates.loading)); // Emit loading state
      
      await _tryEmitScrumCards(emit);
    });

    // Get by id handler
    on<FetchScrumCard>((event, emit) async {
      emit(DisplayScrumCard(state: CrudStates.loading)); // Emit loading state

      await _tryEmitScrumCards(emit);
    });

    // Delete event handler
    on<DeleteScrumCard>((event, emit) async {
      ScrumCardDataHandler handler = locator<ScrumCardDataHandler>(); // Inject handler
      await handler.delete(event.id);
      
      await _tryEmitScrumCards(emit);
    });
  }
}