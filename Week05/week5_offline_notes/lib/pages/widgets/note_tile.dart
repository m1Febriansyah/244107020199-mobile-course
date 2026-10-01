import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/note.dart';
import '../notes_page.dart';

class NoteTile extends ConsumerWidget {
  const NoteTile({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(note.title),
      subtitle: Text(
        note.body.isEmpty ? '(Kosong)' : note.body,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (note.dirty)
            const Icon(Icons.sync_problem, size: 16, color: Colors.orange),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              ref.read(notesProvider.notifier).deleteNote(note.id!);
            },
          ),
        ],
      ),
      onTap: () {
        // Akan digunakan untuk navigasi GoRouter nanti
      },
    );
  }
}