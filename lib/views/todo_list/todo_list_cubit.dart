import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_2/repositories/todo/models/todo_item.dart';
import 'package:todo_list_2/repositories/todo/todo_repository.dart';
import 'package:todo_list_2/views/todo_list/todo_list_state.dart';

/// {@template todo_list_cubit}
/// A cubit for managing the todo_list.
/// {@endtemplate}
class TodoListCubit extends Cubit<TodoListState> {
  /// {@macro todo_list_cubit}
  TodoListCubit(
    this._todoRepository,
  ) : super(const TodoListLoading()) {
    loadTodos();
  }

  final TodoRepository _todoRepository;

  /// Loads the todo_list.
  Future<void> loadTodos() async {
    emit(const TodoListLoading());

    final todos = await _todoRepository.getTodos();

    emit(TodoListLoaded(todos));
  }

  /// Adds a todo_item.
  Future<void> addTodo({
    required String title,
    required String subtitle,
  }) async {
    if (state is! TodoListLoaded) {
      return;
    }
    final todoItem = TodoItem(
      title: title,
      subtitle: subtitle,
    );

    unawaited(
      _todoRepository.addTodo(
        todoItem,
      ),
    );

    final todos = (state as TodoListLoaded).todos;
    emit(TodoListLoaded([...todos, todoItem]));
  }

  /// Check a todo_item.
  Future<void> checkTodo({
    required TodoItem todoItem,
  }) async {
    if (state is! TodoListLoaded) {
      return;
    }

    final todos = (state as TodoListLoaded).todos;

    unawaited(
      _todoRepository.removeTodo(
        todoItem,
      ),
    );

    emit(
      TodoListLoaded(
        todos.where((element) => element.id != todoItem.id).toList(),
      ),
    );
  }
}
