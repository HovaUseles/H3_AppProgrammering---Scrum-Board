import '../../../models/_models.dart';

abstract class ScrumCardCrudEvent {}

class FetchScrumCards extends ScrumCardCrudEvent {}


class FetchScrumCard extends ScrumCardCrudEvent {
    final String id;

  FetchScrumCard({
    required this.id
  });
}

class CreateScrumCard extends ScrumCardCrudEvent {
  final int index;
  final String title;
  final String content;
  final ScrumColumn scrumColumn;

  CreateScrumCard({
    required this.index,
    required this.title,
    required this.content,
    required this.scrumColumn
    });
}

class EditScrumCard extends ScrumCardCrudEvent {
  final ScrumCard scrumCard;

  EditScrumCard({
    required this.scrumCard
  });
}

class DeleteScrumCard extends ScrumCardCrudEvent {
  final String id;

  DeleteScrumCard({
    required this.id
  });
}