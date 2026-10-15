import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Gunakan dummy data untuk memicu mock login di Praktikum 1
            ref.read(authStateProvider.notifier).login('test@kampus.id', 'password123');
          },
          child: const Text('Masuk (Mock)'),
        ),
      ),
    );
  }
}