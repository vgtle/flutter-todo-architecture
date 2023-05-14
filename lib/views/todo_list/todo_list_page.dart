import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_2/repositories/todo/todo_repository.dart';
import 'package:todo_list_2/views/todo_list/todo_list_cubit.dart';
import 'package:todo_list_2/views/todo_list/todo_list_state.dart';
import 'package:todo_list_2/widgets/todo_list_item.dart';

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
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerSubtitle = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllerSubtitle.addListener(_onTyped);
    _controllerTitle.addListener(_onTyped);
  }

  void _onTyped() {
    setState(() {});
  }

  @override
  void dispose() {
    _controllerSubtitle.removeListener(_onTyped);
    _controllerTitle.removeListener(_onTyped);
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
      body: BlocProvider(
        create: (context) => TodoListCubit(
          context.read<TodoRepository>(),
        ),
        child: Builder(
          builder: (context) {
            final state = context.watch<TodoListCubit>().state;
            if (state is TodoListLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final todos = (state as TodoListLoaded).todos;
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
                      onChecked: () => context.read<TodoListCubit>().checkTodo(
                            todoItem: todo,
                          ),
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
                                  onFieldSubmitted: (_) => _addTodo,
                                ),
                                TextFormField(
                                  controller: _controllerSubtitle,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(16),
                                    hintText: 'Subtitle',
                                  ),
                                  onFieldSubmitted: (_) => _addTodo,
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
                                : _addTodo,
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
      ),
    );
  }

  void _addTodo() {
    context.read<TodoListCubit>().addTodo(
          title: _controllerTitle.text,
          subtitle: _controllerSubtitle.text,
        );
    clearTextfields();
  }

  void clearTextfields() {
    _controllerTitle.clear();
    _controllerSubtitle.clear();
  }
}
