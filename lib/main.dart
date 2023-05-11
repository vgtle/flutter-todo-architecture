import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

/// {@template my_app}
/// This is the main application widget.
/// {@endtemplate}
class MyApp extends StatelessWidget {
  /// {@macro my_app}
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pink,
      ),
      home: const TodoListPage(),
    );
  }
}

/// {@template todo_list_page}
/// A page that shows a list of todos.
/// {@endtemplate}
class TodoListPage extends StatefulWidget {
  /// {@macro todo_list_page}
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  static const _todosKey = 'todos';
  late final SharedPreferences prefs;
  late final List<TodoItem> todos;
  bool isInitializing = true;
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerSubtitle = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) async {
      prefs = value;
      final savedTodos = value.getStringList(_todosKey);
      await Future<void>.delayed(const Duration(seconds: 1));

      setState(() {
        todos = savedTodos
                ?.map(
                  (e) => TodoItem.fromJson(
                    jsonDecode(e) as Map<String, dynamic>,
                  ),
                )
                .toList() ??
            [];
        isInitializing = false;
      });
      _controllerSubtitle.addListener(() {
        setState(() {});
      });
      _controllerTitle.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _controllerSubtitle.dispose();
    _controllerTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Builder(
        builder: (context) {
          if (isInitializing) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return TodoListItem(
                    key: ValueKey(todo.id),
                    title: Text(todo.title),
                    subtitle: Text(todo.subtitle),
                    onChecked: () => setState(() {
                      removeTodoAtIndex(index);
                    }),
                  );
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Card(
                  elevation: 6,
                  margin: const EdgeInsets.all(36),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _controllerTitle,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(16),
                                  hintText: 'Title',
                                ),
                                onFieldSubmitted: (value) {
                                  addTodo();
                                },
                              ),
                              TextFormField(
                                controller: _controllerSubtitle,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(16),
                                  hintText: 'Subtitle',
                                ),
                                onFieldSubmitted: (value) {
                                  addTodo();
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 1,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            color: _controllerSubtitle.text.isEmpty ||
                                    _controllerTitle.text.isEmpty
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.4)
                                : Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: _controllerSubtitle.text.isEmpty ||
                                  _controllerTitle.text.isEmpty
                              ? null
                              : addTodo,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void addTodo() {
    setState(() {
      todos.add(
        TodoItem(
          title: _controllerTitle.text,
          subtitle: _controllerSubtitle.text,
        ),
      );
      prefs.setStringList(_todosKey, todos.map(jsonEncode).toList());
      _controllerTitle.clear();
      _controllerSubtitle.clear();
    });
  }

  void removeTodoAtIndex(int index) {
    todos.removeAt(index);

    prefs.setStringList(_todosKey, todos.map(jsonEncode).toList());
  }
}

/// {@template todo_list_item}
/// A list item that shows a todo_item.
/// {@endtemplate}
class TodoListItem extends StatefulWidget {
  /// {@macro todo_list_item}
  const TodoListItem({
    required this.title,
    required this.subtitle,
    super.key,
    this.onChecked,
  });

  /// The title of the todo_item.
  final Widget title;

  /// The subtitle of the todo_item.
  final Widget subtitle;

  /// Called when the todo_item is checked.
  final VoidCallback? onChecked;

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  late var _checked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: widget.title,
        subtitle: widget.subtitle,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: _checked,
              onChanged: (_) {
                widget.onChecked?.call();
                setState(() {
                  _checked = true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// {@template todo_item}
/// A todo_item.
/// {@endtemplate}
class TodoItem {
  /// {@macro todo_item}
  factory TodoItem({
    required String title,
    required String subtitle,
  }) {
    return TodoItem._(
      title: title,
      subtitle: subtitle,
      id: const Uuid().v4(),
    );
  }

  /// Returns a todo_item from a json map.
  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem._(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      id: json['id'] as String,
    );
  }

  TodoItem._({
    required this.title,
    required this.subtitle,
    required this.id,
  });

  /// The id of the todo_item.
  late final String id;

  /// The title of the todo_item.
  final String title;

  /// The subtitle of the todo_item.
  final String subtitle;

  /// Returns a json map from the todo_item.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
    };
  }
}
