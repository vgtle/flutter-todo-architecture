import 'package:uuid/uuid.dart';

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
