import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_2/repositories/todo/todo_repository.dart';
import 'package:todo_list_2/views/todo_list/todo_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  runApp(MyApp(preferences));
}

/// {@template my_app}
/// This is the main application widget.
/// {@endtemplate}
class MyApp extends StatelessWidget {
  /// {@macro my_app}
  const MyApp(this.preferences, {super.key});

  /// The [SharedPreferences] instance.
  final SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TodoRepository(
        preferences,
      ),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Todo List',
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.pink,
            ),
            home: const TodoListPage(),
          );
        },
      ),
    );
  }
}
