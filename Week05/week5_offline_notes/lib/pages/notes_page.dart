import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/note.dart';
import '../data/repositories/note_repository.dart';
import 'settings_page.dart';

// ==========================================
// 1. REPOSITORY & PROVIDER
// ==========================================
final noteRepositoryProvider = Provider((ref) => NoteRepository());
final notesProvider = AsyncNotifierProvider<NotesNotifier, List<Note>>(NotesNotifier.new);

class NotesNotifier extends AsyncNotifier<List<Note>> {
  @override
  Future<List<Note>> build() async => ref.watch(noteRepositoryProvider).fetchNotes();

  Future<void> addNote(String title, String body) async {
    await ref.read(noteRepositoryProvider).addNote(title: title, body: body);
    ref.invalidateSelf(); 
  }

  Future<void> deleteNote(int id) async {
    await ref.read(noteRepositoryProvider).deleteNote(id);
    ref.invalidateSelf();
  }

  // Fungsi sinkronisasi (simulasi)
  Future<void> syncNotes(bool forceOffline) async {
    if (forceOffline) {
      throw Exception('Simulasi Offline aktif! Matikan dulu untuk sinkronisasi.');
    }

    final repo = ref.read(noteRepositoryProvider);
    final dirtyCount = await repo.countDirty();
    
    if (dirtyCount == 0) return;

    await Future.delayed(const Duration(seconds: 2));
    await repo.markAllSynced();
    ref.invalidateSelf(); 
  }
}

final dirtyCountProvider = FutureProvider<int>((ref) async {
  ref.watch(notesProvider); 
  return ref.watch(noteRepositoryProvider).countDirty();
});

// ==========================================
// 2. UI NOTES PAGE
// ==========================================
class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesState = ref.watch(notesProvider);
    final dirtyCount = ref.watch(dirtyCountProvider).value ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Notes'),
        actions: [
          if (dirtyCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Badge(
                  label: Text(dirtyCount.toString()),
                  child: const Icon(Icons.cloud_upload_outlined),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: notesState.when(
        data: (notes) {
          if (notes.isEmpty) return const Center(child: Text('Belum ada catatan.'));
          
          // RefreshIndicator membungkus ListView
          return RefreshIndicator(
            onRefresh: () async {
              final isOffline = ref.read(forceOfflineProvider);
              try {
                await ref.read(notesProvider.notifier).syncNotes(isOffline);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sinkronisasi selesai!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.body),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (note.dirty)
                        const Icon(Icons.sync_problem, size: 16, color: Colors.orange),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => ref.read(notesProvider.notifier).deleteNote(note.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Catatan Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Judul')),
            TextField(controller: bodyController, decoration: const InputDecoration(labelText: 'Isi')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          FilledButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                ref.read(notesProvider.notifier).addNote(titleController.text, bodyController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}