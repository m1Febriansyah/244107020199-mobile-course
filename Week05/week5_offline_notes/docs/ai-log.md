# AI Log

## Prompt Mentah

> Minta AI membuat **pencarian judul notes** lengkap dengan empty state. Batasi satu fitur agar mudah diverifikasi.
>
> Konteks aplikasi: Flutter Offline Notes pada `Week05/week5_offline_notes`.
>
> Batasan fitur:
>
> - Pencarian hanya berdasarkan judul note.
> - Pencarian tidak membedakan huruf besar dan kecil.
> - Query kosong menampilkan semua notes.
> - Query yang tidak cocok menampilkan empty state yang jelas.
> - Jangan mengubah fitur lain.

## Output Awal AI

Implementasikan helper Dart murni berikut di `lib/domain/note_filter.dart`:

```dart
import '../data/local/note.dart';

List<Note> filterNotes(List<Note> notes, String query) {
  final normalizedQuery = query.trim().toLowerCase();
  if (normalizedQuery.isEmpty) return notes;

  return notes
      .where((note) => note.title.toLowerCase().contains(normalizedQuery))
      .toList();
}
```

Gunakan helper tersebut di halaman daftar notes dengan state query lokal dan `TextField` pada `AppBar`. Saat query kosong, tampilkan seluruh notes. Saat query tidak menemukan judul yang cocok, tampilkan empty state, misalnya:

```dart
const Center(
  child: Text('Tidak ada catatan yang cocok.'),
)
```

Alur implementasi awal:

1. Tambahkan `TextEditingController` atau state query pada `NotesPage`.
2. Filter hasil `notesProvider` menggunakan `filterNotes`.
3. Render hasil filter pada daftar yang sudah ada.
4. Bedakan empty state "belum ada catatan" dari empty state "tidak ada catatan yang cocok".
5. Tambahkan test untuk query yang mengabaikan huruf besar/kecil dan query yang tidak cocok.

Fitur dibatasi pada pencarian judul dan empty state; repository, database, sinkronisasi, dan navigasi tidak diubah.
