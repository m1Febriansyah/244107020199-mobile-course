import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week_todo/main.dart'; // pastikan nama package sesuai (week_todo)

void main() {
  testWidgets('menambah tugas baru', (tester) async {
    // Bangun aplikasi beserta ProviderScope-nya
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    
    // Memastikan router berhasil merender halaman ToDo dan state awalnya kosong
    await tester.pumpAndSettle();
    expect(find.text('Belum ada tugas'), findsOneWidget);

    // Cari tombol tambah (+)
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Ketik inputan di TextField Dialog
    await tester.enterText(find.byType(TextField), 'Kerjakan PR minggu 3');
    await tester.tap(find.text('Tambah'));
    
    // Tunggu rendering dan dialog menutup
    await tester.pumpAndSettle();

    // Pastikan task baru berhasil tampil di UI
    expect(find.text('Kerjakan PR minggu 3'), findsOneWidget);
  });
}