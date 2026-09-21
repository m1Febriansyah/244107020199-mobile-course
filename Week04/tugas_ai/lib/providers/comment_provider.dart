import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Gunakan jalur relatif (mundur satu folder lalu masuk ke folder tujuan)
import '../models/comment_model.dart'; 
import '../repositories/comment_repository.dart'

// Provider dasar untuk Dependency Injection (Dio dan Repository)
final dioProvider = Provider<Dio>((ref) => Dio());

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  // Inject Dio provider ke dalam Repository
  return CommentRepository(ref.watch(dioProvider));
});

// AsyncNotifier menggunakan modifier "family" untuk menerima argumen int (postId),
// dan "autoDispose" untuk membuang state dari memori saat UI dihancurkan.
class CommentNotifier extends AutoDisposeFamilyAsyncNotifier<List<Comment>, int> {
  
  @override
  Future<List<Comment>> build(int arg) async {
    // Argumen di sini bertindak sebagai 'postId'
    // Build akan otomatis dijalankan saat provider pertama kali di-listen.
    return _fetchComments(arg);
  }

  Future<List<Comment>> _fetchComments(int postId) async {
    final repository = ref.watch(commentRepositoryProvider);
    
    // Pemanggilan ini secara otomatis di-wrap dalam try-catch internal oleh Riverpod.
    // Jika repository melempar exception (misal: timeout atau 404),
    // state otomatis berubah menjadi AsyncValue.error().
    return await repository.fetchComments(postId);
  }
}

// Deklarasi provider yang dapat dipanggil di bagian UI (ConsumerWidget)
final commentNotifierProvider = AsyncNotifierProvider.autoDispose.family<CommentNotifier, List<Comment>, int>(
  () => CommentNotifier(),
);