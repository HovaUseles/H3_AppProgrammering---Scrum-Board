import 'package:app_scrum_board/blocs/scrum_card/scrum_card_bloc.dart';
import 'package:app_scrum_board/data_access/scrum_card_data_handler.dart';
import 'package:app_scrum_board/services/locators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/_models.dart';
import 'screens/scrum_board.dart';

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
      home: MultiBlocProvider(
          providers: [
            BlocProvider<ScrumCardCrudBloc>(
              create: (context) => ScrumCardCrudBloc(),
            ),
          ],
          child: const MyHomePage(title: 'Scrum Board Home Page'),
        )
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ScrumBoard(),
      // body: ListView.builder(
      //   itemCount: 10,
      //   itemBuilder: (context, index) => ScrumCardItem(
      //     title: "Title",
      //     assignedTo: "Someone",
      //     content: "Content",
      //   ),
      // ),
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
