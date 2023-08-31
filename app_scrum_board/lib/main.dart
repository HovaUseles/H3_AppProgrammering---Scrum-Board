import 'package:app_scrum_board/data_access/scrum_card_data_handler.dart';
import 'package:app_scrum_board/services/locators.dart';
import 'package:app_scrum_board/widget/scrum_card_item.dart';
import 'package:flutter/material.dart';

import 'models/_models.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrum Board',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Scrum Board Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    ScrumCardDataHandler _handler =
        locator<ScrumCardDataHandler>(); // Inject handler

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => ScrumCardItem(
          title: "Title",
          assignedTo: "Someone",
          content: "Content",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
