import 'package:todo_list_2/repositories/todo/models/todo_item.dart';

/// {@template todo_list_state}
/// The state of the todo_list.
/// {@endtemplate}
abstract class TodoListState {
  /// {@macro todo_list_state}
  const TodoListState();
}

/// {@template todo_list_loading}
/// The todo_list loading state.
/// {@endtemplate}
class TodoListLoading extends TodoListState {
  /// {@macro todo_list_loading}
  const TodoListLoading();
}

/// {@template todo_list_loaded}
/// The todo_list loaded state.
/// {@endtemplate}
class TodoListLoaded extends TodoListState {
  /// {@macro todo_list_loaded}
  const TodoListLoaded(this.todos);

  /// The list of todo_items.
  final List<TodoItem> todos;
}
