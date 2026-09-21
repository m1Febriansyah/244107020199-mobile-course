import 'package:flutter_test/flutter_test.dart';
// Import wajib menggunakan awalan package:nama_folder_project/
import 'package:tugas_ai/models/comment_model.dart';

void main() {
  group('Comment Model Tests', () {
    test('fromJson harus mengembalikan default value yang aman ketika JSON kosong/field hilang', () {
      // Arrange: Simulasi API mengembalikan dictionary (Map) kosong, 
      // yang artinya semua required fields tidak ada (missing fields).
      final Map<String, dynamic> emptyJson = {};

      // Act: Eksekusi proses parsing data
      final comment = Comment.fromJson(emptyJson);

      // Assert: Pastikan semua field mendapatkan nilai fallback yang aman
      expect(comment.postId, 0); // Sesuai fallback default
      expect(comment.id, 0);
      expect(comment.name, 'Unknown Name');
      expect(comment.email, 'No Email');
      expect(comment.body, 'No Content');
    });
    
    test('fromJson harus mengembalikan default value ketika data bernilai eksplisit null', () {
      // Arrange: Simulasi API mengembalikan key yang ada tetapi valuenya null
      final Map<String, dynamic> nullJson = {
        'postId': null,
        'id': null,
        'name': null,
        'email': null,
        'body': null,
      };

      // Act
      final comment = Comment.fromJson(nullJson);

      // Assert
      expect(comment.postId, 0);
      expect(comment.email, 'No Email');
    });
  });
}