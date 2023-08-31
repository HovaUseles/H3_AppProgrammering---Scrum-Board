
import 'dart:convert';

import 'package:app_scrum_board/models/entity_model.dart';

enum ScrumColumn { todo, doing, done}

class ScrumCard extends EntityModel {
  final int index;
  final String title;
  final String content;
  final ScrumColumn scrumColumn;

  ScrumCard({
    String? id,
    required this.index,
    required this.title,
    required this.content,
    required this.scrumColumn
  }) : super(id: id);

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'id': id});
    result.addAll({'index': index});
    result.addAll({'title': title});
    result.addAll({'content': content});
    result.addAll({'scrumColumn': scrumColumn.index});

    return result;
  }

  factory ScrumCard.fromMap(Map<String, dynamic> map) {
    return ScrumCard(
      id: map["id"], 
      index: map["index"] ?? "", 
      title: map["title"] ?? "", 
      content: map["content"] ?? "", 
      scrumColumn: ScrumColumn.values[map["scrumColumn"]]
    );
  }

  factory ScrumCard.fromJson(String jsonSource) =>
      ScrumCard.fromMap(json.decode(jsonSource));

  String toJson() => json.encode(toMap()); // Turn Model into json

}