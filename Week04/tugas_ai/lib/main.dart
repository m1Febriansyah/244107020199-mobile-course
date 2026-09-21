import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/comment_provider.dart';

// Import file provider yang sudah dibuat sebelumnya
// Sesuaikan path ini dengan nama project-mu
import 'providers/comment_provider.dart'; 

void main() {
  runApp(
    // Wajib dibungkus ProviderScope agar Riverpod berfungsi di seluruh aplikasi
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Riverpod Dio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      // Kita coba tampilkan komentar untuk Post dengan ID = 1
      home: const CommentScreen(postId: 1), 
    );
  }
}

// Gunakan ConsumerWidget (bukan StatelessWidget) untuk bisa mengakses WidgetRef
class CommentScreen extends ConsumerWidget {
  final int postId;

  const CommentScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Membaca state dari provider.
    // Karena kita pakai '.family', kita harus mengirimkan argumen postId-nya.
    final asyncComments = ref.watch(commentNotifierProvider(postId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Komentar Post #$postId'),
        backgroundColor: Colors.blue.shade100,
      ),
      // .when otomatis memetakan state ke 3 kondisi UI
      body: asyncComments.when(
        // Kondisi 1: Data berhasil diambil (Success)
        data: (comments) {
          if (comments.isEmpty) {
            return const Center(child: Text('Tidak ada komentar.'));
          }
          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(comment.id.toString()),
                  ),
                  title: Text(
                    comment.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(comment.body),
                ),
              );
            },
          );
        },
        
        // Kondisi 2: Sedang memuat data (Loading)
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        
        // Kondisi 3: Terjadi Error (akan menampilkan pesan ramah pengguna)
        error: (error, stackTrace) {
          // Menghapus tulisan "Exception: " bawaan Dart agar UI lebih rapi
          final errorMessage = error.toString().replaceAll('Exception: ', '');
          
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      // refresh data / Coba Lagi
                      // invalidate akan me-reset state provider dan memicu request ulang
                      ref.invalidate(commentNotifierProvider(postId));
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}