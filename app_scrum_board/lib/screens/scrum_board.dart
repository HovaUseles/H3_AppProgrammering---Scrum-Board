import 'package:app_scrum_board/widget/scrum_card_item.dart';
import 'package:flutter/material.dart';
import 'package:kanban_board/custom/board.dart';
import 'package:kanban_board/models/inputs.dart';

class ScrumBoard extends StatelessWidget {
  ScrumBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return KanbanBoard(
      List.generate(
        3,
        (index) => BoardListsData(
          title: "List $index",
          width: 250,
          headerBackgroundColor: Color.fromARGB(255, 235, 236, 240),
          footerBackgroundColor: Color.fromARGB(255, 235, 236, 240),
          backgroundColor: Color.fromARGB(255, 235, 236, 240),
          items: List.generate(
            3,
            (index) => Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  )),
              padding: const EdgeInsets.all(8.0),
              child: Dismissible(
                key: const Key('0'),
                onDismissed: (direction) {},
                background: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete_forever_outlined)),
                child: ScrumCardItem(
                    title: "title",
                    assignedTo: "assignedTo",
                    content: "content"),
              ),
            ),
          ),
        ),
      ),
      onItemLongPress: (cardIndex, listIndex) {},
      onItemReorder:
          (oldCardIndex, newCardIndex, oldListIndex, newListIndex) {},
      onItemTap: (cardIndex, listIndex) {},
      backgroundColor: Colors.white,
      displacementY: 124,
      displacementX: 100,
      textStyle: const TextStyle(
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
    );
  }
}
