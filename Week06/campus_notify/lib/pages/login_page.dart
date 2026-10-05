import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import provider mu...

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Contoh memanggil fungsi login
            // ref.read(authStateProvider.notifier).login('test@test.com', '123456');
          },
          child: const Text('Simulasi Login'),
        ),
      ),
    );
  }
}