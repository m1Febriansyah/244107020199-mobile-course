import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/note.dart';
import 'notes_page.dart';

class NoteDetailPage extends ConsumerWidget {
  const NoteDetailPage({super.key, required this.noteId});
  final int noteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesState = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Catatan')),
      body: notesState.when(
        data: (notes) {
          // Cari catatan berdasarkan ID
          final note = notes.firstWhere(
            (n) => n.id == noteId,
            orElse: () => Note(id: -1, title: 'Not Found', body: '', updatedAt: DateTime.now()),
          );

          if (note.id == -1) return const Center(child: Text('Catatan tidak ditemukan'));

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                Text(note.body, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}