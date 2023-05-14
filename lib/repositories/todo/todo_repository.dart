import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_2/repositories/todo/models/todo_item.dart';

/// {@template todo_repository}
/// A repository for managing todo_items.
/// {@endtemplate}
class TodoRepository {
  /// {@macro todo_repository}
  const TodoRepository(this._sharedPreferences);

  static const _todosKey = 'todos';

  final SharedPreferences _sharedPreferences;

  /// Returns a list of todo_items.
  Future<List<TodoItem>> getTodos() async {
    final savedTodos = _sharedPreferences.getStringList(_todosKey);
    final parsedTodos = savedTodos
            ?.map(
              (e) => TodoItem.fromJson(
                jsonDecode(e) as Map<String, dynamic>,
              ),
            )
            .toList() ??
        [];
    return parsedTodos;
  }

  /// Adds a todo_item.
  Future<void> addTodo(TodoItem todoItem) async {
    final todos = await getTodos();
    todos.add(todoItem);
    await _storeTodos(todos);
  }

  /// Removes a todo_item.
  Future<void> removeTodo(TodoItem todoItem) async {
    final todos = await getTodos();
    await _storeTodos(
      todos.where((element) => element.id != todoItem.id).toList(),
    );
  }

  Future<void> _storeTodos(List<TodoItem> todos) async {
    await _sharedPreferences.setStringList(
      _todosKey,
      todos.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }
}
