import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/notes_page.dart'; // untuk akses notesProvider

final syncProvider = Provider((ref) => SyncService(ref));

class SyncService {
  final Ref ref;
  SyncService(this.ref);

  Future<void> syncNotes(bool forceOffline) async {
    if (forceOffline) {
      throw Exception('Simulasi Offline aktif! Matikan dulu untuk sinkronisasi.');
    }

    final repo = ref.read(noteRepositoryProvider);
    final dirtyCount = await repo.countDirty();
    
    if (dirtyCount == 0) return;

    // Simulasi delay upload ke server REST API
    await Future.delayed(const Duration(seconds: 2));
    await repo.markAllSynced();
    
    // Invalidasi agar UI refresh otomatis
    ref.invalidate(notesProvider);
  }
}