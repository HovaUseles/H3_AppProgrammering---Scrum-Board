import 'package:flutter/material.dart';

class ScrumCardItem extends StatelessWidget {
  final String title;
  final String assignedTo;
  final String content;

  final Color? backgroundColor;

  const ScrumCardItem(
      {super.key,
      required this.title,
      required this.assignedTo,
      required this.content,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "Assigned to: $assignedTo",
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              content,
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
  
}
