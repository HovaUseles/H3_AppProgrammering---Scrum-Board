import 'package:app_scrum_board/widget/scrum_card_item.dart';
import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/scrum_card/event/scrum_card_bloc_event.dart';
import '../blocs/scrum_card/scrum_card_bloc.dart';
import '../blocs/scrum_card/state/scrum_card_bloc_state.dart';
import '../models/_models.dart';

class ScrumBoard extends StatelessWidget {
  ScrumBoard({super.key});

  final AppFlowyBoardController controller = AppFlowyBoardController(
    onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      // debugPrint('Move item from $fromIndex to $toIndex');
    },
    onMoveGroupItem: (groupId, fromIndex, toIndex) {
      // debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');
    },
    onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      // debugPrint('Move $fromGroupId:$fromIndex to $toGroupId:$toIndex');
    },
  );

  final AppFlowyBoardScrollController scrollController =
      AppFlowyBoardScrollController();

  int sortScrumCards(ScrumCard a, ScrumCard b) {
    final aIndex = a.index;
    final bIndex = b.index;
    if (aIndex < bIndex) {
      return -1;
    } else if (aIndex > bIndex) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrumCardCrudBloc crudBloc =
        BlocProvider.of<ScrumCardCrudBloc>(context); // Inject

    return BlocBuilder<ScrumCardCrudBloc, ScrumCardCrudState>(
      builder: (BuildContext context, ScrumCardCrudState state) {
        if (state.state == CrudStates.initial) {
          crudBloc.add(FetchScrumCards()); // Fetch on initial
        }
        if (state is DisplayScrumCards) {
          if (state.state == CrudStates.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.state == CrudStates.error) {
            return const Text("An error occured.");
          }
          if (state.scrumCards != null) {
            if (state.scrumCards!.isEmpty) {
              return const Text("No data");
            }
            state.scrumCards!.sort(sortScrumCards);
            List<ScrumCard> todoGroup = [];
            List<ScrumCard> doingGroup = [];
            List<ScrumCard> doneGroup = [];

            for (ScrumCard scrumCard in state.scrumCards!) {
              switch (scrumCard.scrumColumn) {
                case ScrumColumn.todo:
                  todoGroup.add(scrumCard);
                  break;
                case ScrumColumn.doing:
                  doingGroup.add(scrumCard);
                  break;
                case ScrumColumn.done:
                  doneGroup.add(scrumCard);
                  break;
              }
            }
            // Build groups
            final group1 = AppFlowyGroupData(
                id: ScrumColumn.todo.name, 
                name: "To do", 
                items: List<AppFlowyGroupItem>.from(todoGroup));
            final group2 = AppFlowyGroupData(
                id: ScrumColumn.doing.name, 
                name: "Doing", 
                items: List<AppFlowyGroupItem>.from(doingGroup));
            final group3 = AppFlowyGroupData(
                id: ScrumColumn.done.name, 
                name: "Done", 
                items: List<AppFlowyGroupItem>.from(doneGroup));

            group1.draggable = false;
            group2.draggable = false;
            group3.draggable = false;

            controller.addGroup(group1);
            controller.addGroup(group2);
            controller.addGroup(group3);

            // build board
            return AppFlowyBoard(
              config: const AppFlowyBoardConfig(
                groupBackgroundColor: Colors.grey,
              ),
              boardScrollController: scrollController,
              groupConstraints: const BoxConstraints.tightFor(width: 320),
              headerBuilder: (context, groupData) {
                return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      groupData.headerData.groupName,
                      style: const TextStyle(fontSize: 20),
                    ));
              },
              controller: controller,
              cardBuilder: (context, group, groupItem) {
                final scrumCard = groupItem as ScrumCard; // Get GroupItem
                return AppFlowyGroupCard(
                  key: ValueKey(scrumCard.id),
                  child: ScrumCardItem(
                      title: scrumCard.title,
                      assignedTo: "All",
                      content: scrumCard.content),
                );
              },
            );
          }
          return const Text("No data");
        }
        return const Text("No data");
      },
    );
  }

  /*
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
    */
}
