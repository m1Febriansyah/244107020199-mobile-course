import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';

class TodoTile extends ConsumerWidget {
  final Todo todo;

  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Cari index asli dari data keseluruhan untuk menghindari salah hapus ketika di filter
    final originalIndex = ref.read(todoListProvider).indexOf(todo);

    return ListTile(
      leading: Checkbox(
        value: todo.done,
        onChanged: (_) =>
            ref.read(todoListProvider.notifier).toggle(originalIndex),
      ),
      title: Text(
        todo.title,
        style: TextStyle(
            decoration: todo.done ? TextDecoration.lineThrough : null),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () =>
            ref.read(todoListProvider.notifier).remove(originalIndex),
      ),
    );
  }
}