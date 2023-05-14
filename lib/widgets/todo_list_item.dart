import 'package:flutter/material.dart';

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
