import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';

import '../local/db.dart';
import '../local/post.dart';

class PostRepository {
  PostRepository({Future<Database> Function()? openDb})
      : _openDb = openDb ?? openNotesDb;

  final Future<Database> Function() _openDb;
  final Dio _dio = Dio();

  // 1. Baca data dari Cache (SQLite)
  Future<List<Post>> readCachedPosts() async {
    final db = await _openDb();
    final rows = await db.query('cached_posts');
    if (rows.isEmpty) return [];

    final payload = rows.first['payload'] as String;
    final List<dynamic> data = json.decode(payload);
    return data.map((e) => Post.fromMap(e)).toList();
  }

  // 2. Fetch API di Background -> Simpan ke Cache
  Future<bool> refreshPostsInBackground(bool forceOffline) async {
    if (forceOffline) return false; // Batalkan jika simulasi offline aktif

    try {
      final response = await _dio.get('https://jsonplaceholder.typicode.com/posts');
      if (response.statusCode == 200) {
        final db = await _openDb();
        final payload = json.encode(response.data);

        await db.transaction((txn) async {
          await txn.delete('cached_posts'); // Hapus cache lama
          await txn.insert('cached_posts', {
            'id': 1,
            'payload': payload,
            'cached_at': DateTime.now().toIso8601String(),
          });
        });
        return true; // Berhasil update cache
      }
    } catch (e) {
      // Abaikan error jaringan agar tidak merusak UI (karena ini background)
    }
    return false;
  }
}