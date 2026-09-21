import 'package:dio/dio.dart';
import '../models/comment_model.dart';

// Fungsi helper untuk menerjemahkan DioException dan error lainnya 
// menjadi pesan yang mudah dimengerti oleh pengguna.
String getFriendlyErrorMessage(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi terlalu lama (Timeout 10 detik). Silakan coba lagi.';
      case DioExceptionType.connectionError:
        return 'Tidak ada koneksi internet. Periksa jaringan Anda.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 404) {
          return 'Data komentar tidak ditemukan (Error 404).';
        } else if (statusCode == 500 || statusCode == 502) {
          return 'Terjadi masalah pada server. Coba beberapa saat lagi (Error 500).';
        }
        return 'Terjadi kesalahan pada sistem: $statusCode';
      default:
        return 'Terjadi kesalahan jaringan yang tidak diketahui.';
    }
  }
  return 'Terjadi kesalahan tak terduga.';
}

class CommentRepository {
  final Dio _dio;

  CommentRepository(this._dio) {
    // Konfigurasi Base URL dan Timeout 10 detik sesuai requirement
    _dio.options.baseUrl = 'https://jsonplaceholder.typicode.com';
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  // Method untuk mengambil komentar berdasarkan postId
  Future<List<Comment>> fetchComments(int postId) async {
    try {
      final response = await _dio.get(
        '/comments',
        queryParameters: {'postId': postId}, // Menambahkan ?postId={id} ke endpoint
      );
      
      // Map data JSON dari response ke List of Comment
      final List data = response.data;
      return data.map((json) => Comment.fromJson(json)).toList();
      
    } catch (e) {
      // Tangkap error, terjemahkan dengan helper, dan lempar kembali 
      // sebagai custom Exception agar bisa ditangkap oleh Riverpod
      throw Exception(getFriendlyErrorMessage(e));
    }
  }
}